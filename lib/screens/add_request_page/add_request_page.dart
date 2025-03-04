import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '/init.dart';
import '../../core/constants/routes.dart';
import '../../core/constants/strings.dart';
import '../../custom/widgets/alert_dialog.dart';
import '../../storage/models/request_model.dart';

class AddRequestPage extends StatefulWidget {
  final int? index;
  const AddRequestPage({super.key, this.index});

  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController methodController = TextEditingController();
  final TextEditingController pathController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  final TextEditingController responseController = TextEditingController();

  bool isEditMode = false;
  bool isFormDirty = false;

  Box<Request>? database = historyDatabase;
  int? get index => widget.index;

  void addRequest() async {
    try {
      if (_formKey.currentState!.validate()) {
        final String title = titleController.text;
        final String method = methodController.text;
        final String path = pathController.text;
        final String auth = authController.text;

        final Request request = Request(
          title: title,
          method: method.toUpperCase(),
          path: path,
          body: '',
          headers: {"Content-Type": "application/json"},
          auth: {"Authorization": "Basic $auth"},
        );

        dynamic response = await apiClient.request(request);
        request.response = response.toString();

        setState(() {
          responseController.text = response.toString();
        });
        if (isEditMode == true && index != null) {
          await database!.putAt(index!, request);
        } else {
          await database?.add(request);
        }
      }
    } catch (e) {
      print('Unexpected error occured please try after sometime $e');
    }
  }

  Widget addForm(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: _formElements(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentPath = addRequestPageRoute;
    return addForm(context);
  }

  void clearAllFields() {
    setState(() {
      titleController.text = methodController.text = pathController.text =
          authController.text = responseController.text = '';
      isFormDirty = false;
    });
  }

  Future<bool> confirmDiscard() async {
    final String? response = await showAlertDialog(
        context, 'Confirm', 'Are you sure to discard the request?');
    if (response == ok) {
      clearAllFields();
      setState(() => isFormDirty = false);
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (currentPath == collectionsPageRoute) {
      database = collectionsDatabase!;
    }
    if (index != null) {
      isEditMode = true;
      _loadFormData(database!, index!);
      isFormDirty = true;
    }
    super.initState();
  }

  Widget _add(BuildContext context, String text) {
    return ElevatedButton(onPressed: addRequest, child: Text(text));
  }

  ElevatedButton _cancel(BuildContext context) {
    return ElevatedButton(
      child: const Text(cancel),
      onPressed: () async {
        if (isFormDirty == true) {
          confirmDiscard();
        }
      },
    );
  }

  TextFormField _contentField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: responseText,
        border: OutlineInputBorder(),
      ),
      controller: responseController,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
    );
  }

  List<Widget> _formElements(BuildContext context) {
    return <Widget>[
      Form(
        key: _formKey,
        onChanged: () => setState(() => isFormDirty = true),
        // TODO : Reimplement dirty form check with scope-pop

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _inputFields(context),
        ),
      ),
      Row(
        children: _inputButtons(context),
      ),
    ];
  }

  List<Widget> _inputButtons(BuildContext context) {
    return <Widget>[
      if (isEditMode) _add(context, 'UPDATE') else _add(context, ok),
      const SizedBox(width: 16),
      _cancel(context),
    ];
  }

  List<Widget> _inputFields(BuildContext context) {
    return <Widget>[
      _titleField(),
      const SizedBox(height: 16),
      _methodField(),
      const SizedBox(height: 16),
      _pathField(),
      const SizedBox(height: 16),
      _authField(),
      const SizedBox(height: 16),
      _contentField(),
      const SizedBox(height: 16),
    ];
  }

  TextFormField _textField(
      String labelText, TextEditingController textController) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      textCapitalization: TextCapitalization.sentences,
      controller: textController,
      validator: (String? text) =>
          text!.isEmpty ? '$labelText must not be empty' : null,
    );
  }

  TextFormField _titleField() {
    return _textField('Title', titleController);
  }

  TextFormField _pathField() {
    return _textField('Path', pathController);
  }

  TextFormField _methodField() {
    return _textField('Method', methodController);
  }

  TextFormField _authField() {
    return _textField('Basic Auth', authController);
  }

  void _loadFormData(Box<Request> database, int index) {
    Request request = database.getAt(index)!;
    titleController.text = request.title;
    methodController.text = request.method;
    pathController.text = request.path;
    authController.text = request.auth.values.last.split(' ')[1];
    if (request.response != null) responseController.text = request.response!;
  }
}
