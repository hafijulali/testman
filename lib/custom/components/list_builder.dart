import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../core/constants/routes.dart';
import '../../core/constants/settings.dart';
import '../../core/constants/strings.dart';
import '../../init.dart';
import '../../screens/add_request_page/add_request_page.dart';
import '../../storage/models/request_model.dart';
import '../navigation/navigate.dart';
import '../widgets/app_bar.dart';
import '../widgets/nav_bar.dart';

int listItemOnTapIndex = -1;

StreamBuilder<BoxEvent> listBuilder(
  BuildContext context,
  Box<Request>? data,
) {
  listItemOnTapIndex = -1;
  return StreamBuilder<BoxEvent>(
    stream: settingsDatabase!.watch(),
    builder: (BuildContext context, AsyncSnapshot<BoxEvent> snapshot) {
      return ValueListenableBuilder<Box<Request>?>(
        valueListenable: data!.listenable(),
        builder: (BuildContext context, Box<Request>? todo, _) {
          if (data.isEmpty) {
            return _emptyList(context);
          } else {
            return _list(context, data);
          }
        },
      );
    },
  );
}

IconButton _editButton(BuildContext context, int index) {
  return IconButton(
    tooltip: 'Edit',
    onPressed: () async {
      currentPath = editRequestPageRoute;
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: appBar(context),
              body: AddRequestPage(
                index: index,
              ),
              bottomNavigationBar: navBar(1, (_) => safePop(context)),
            ),
          ));
    },
    icon: const Icon(Icons.edit_outlined),
  );
}

Widget _emptyList(BuildContext context) {
  return Center(
    child: Text(nothingHere, style: TextStyle(fontSize: fontSize)),
  );
}

Widget _item(
  BuildContext context,
  Request? request,
  int index,
) {
  final String titleText =
      '${request!.title} /${request.method} : ${request.path}';
  return ListTile(
    leading: _leadingButton(request.title, index),
    title: _title(titleText),
    subtitle: index == listItemOnTapIndex
        ? _subtitle('$responseText : ${request.response}')
        : null,
    isThreeLine: index == listItemOnTapIndex,
    trailing: Wrap(spacing: 5, children: <IconButton>[
      (currentPath == collectionsPageRoute)
          ? _loadButton(request, index)
          : _editButton(context, index),
    ]),
    onTap: () {
      listItemOnTapIndex = index;
      showSubtitle = !showSubtitle;
      settingsDatabase?.put(showSubtitleKey, showSubtitle);
    },
  );
}

IconButton _leadingButton(String title, int index) {
  Box<Request> database = historyDatabase!;

  if (currentPath == collectionsPageRoute) {
    database = collectionsDatabase!;
  }
  return IconButton(
    onPressed: () async {
      await database.deleteAt(index);
    },
    icon: const Icon(
      Icons.delete_outlined,
      color: Colors.redAccent,
    ),
  );
}

ListView _list(BuildContext context, Box<Request>? data) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: data!.length,
    itemBuilder: (BuildContext context, int index) {
      Request? request = data.getAt(index);
      return _item(context, request, index);
    },
  );
}

Text _subtitle(String text) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    ),
  );
}

Text _title(String text) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    ),
    maxLines: 3,
  );
}

IconButton _loadButton(Request request, int index) {
  return IconButton(
    tooltip: 'Load Collection',
    onPressed: () async {
      historyDatabase?.add(request);
    },
    icon: const Icon(Icons.file_open_outlined),
  );
}
