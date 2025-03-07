import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../core/constants/app.dart';
import '/init.dart';
import '../../core/constants/routes.dart';
import '../../core/constants/strings.dart';
import '../../custom/widgets/alert_dialog.dart';
import '../../storage/models/request_model.dart';

class AddRequestPage extends StatefulWidget {
  final int? index;
  final Box<Request>? database;
  const AddRequestPage({super.key, this.index, this.database});

  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController methodController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController pathController = TextEditingController();
  final TextEditingController authController = TextEditingController();
  final TextEditingController responseController = TextEditingController();

  bool isEditMode = false;
  bool isFormDirty = false;
  bool isSaveToCollection = false;

  Box<Request>? get database => widget.database;
  int? get index => widget.index;

  void addRequest() async {
    Request? request;
    try {
      if (_formKey.currentState!.validate()) {
        String title = titleController.text;
        String method = methodController.text;
        String path = pathController.text;
        String auth = authController.text;
        String body = bodyController.text;
        // INFO : Setting method to GET if its empty
        // as a workaround for issue when state doesn't get updated properly
        if (method.isEmpty) method = 'GET';

        request = Request(
          title: title,
          method: method.toUpperCase(),
          path: path,
          body: body != '' ? jsonDecode(body) : {'': ''},
          headers: {"Content-Type": "application/json"},
          auth: {"Authorization": "Basic $auth"},
        );
        if (isSaveToCollection == true) {
          // INFO : Since, we don't want to preseve the response in Collections database
          await collectionsDatabase?.add(request);
        }

        dynamic response = await apiClient.request(request);
        request.response = response.toString();
        setState(() {
          responseController.text = response.toString();
        });
      }
    } catch (e) {
      if (!context.mounted) {
        showAlertDialog(context, 'Error',
            'Unexpected error occured please try after sometime $e');
      }
    } finally {
      if (isEditMode == true && index != null) {
        await historyDatabase!.putAt(index!, request!);
      } else {
        await historyDatabase?.add(request!);
      }
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
          authController.text =
              bodyController.text = responseController.text = '';
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

  TextFormField _bodyField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: body,
        border: OutlineInputBorder(),
      ),
      controller: bodyController,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _methodField(),
          _pathField(),
        ],
      ),
      const SizedBox(height: 16),
      _authField(),
      const SizedBox(height: 16),
      _bodyField(),
      const SizedBox(height: 16),
      _saveToCollectionSwitch(),
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
          constraints: (labelText == 'Path')
              ? BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width / 1.5)
              : null),
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

  SizedBox _methodField() {
    return SizedBox(
      width: settingsTileWidgetWidth * 0.75,
      child: DropdownMenu<dynamic>(
        hintText: 'GET',
        dropdownMenuEntries: _dropdownMenuEntries(),
        onSelected: (value) {
          setState(() {
            methodController.text = value;
          });
        },
      ),
    );
  }

  List<DropdownMenuEntry> _dropdownMenuEntries() {
    final List<DropdownMenuEntry> menuItems = List.empty(growable: true);
    for (final String element in requestMethods) {
      menuItems.add(
        DropdownMenuEntry(
          value: element,
          label: element,
        ),
      );
    }
    return menuItems;
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

  SwitchListTile _saveToCollectionSwitch() {
    return SwitchListTile(
      title: const Text('Save this to collections'),
      value: isSaveToCollection,
      onChanged: (bool value) {
        setState(() {
          isSaveToCollection = value;
        });
      },
      secondary: const Icon(Icons.save_as_outlined),
    );
  }
}
