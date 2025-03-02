import 'package:flutter/material.dart';

import '../../../init.dart';
import '../../core/constants/routes.dart';
import '../navigation/navigate.dart';
import 'search_bar.dart';
import 'snack_bar.dart';

AppBar appBar(BuildContext context) {
  return AppBar(
    title: Center(
        child: searchBar(context, () {
      showSnackbar(searchTextController.text);
    }, searchTextController, currentPath.substring(1))),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_outlined),
      onPressed: () {
        safePop(context);
      },
    ),
    actions: _actions(context),
  );
}

List<IconButton> _actions(BuildContext context) {
  return <IconButton>[
    IconButton(
      onPressed: () async => await showSnackbar('Refreshing'),
      icon: const Icon(Icons.refresh_outlined),
    ),
    IconButton(
      onPressed: () async => safePush(context, settingsPageRoute),
      icon: const Icon(Icons.settings_outlined),
    ),
  ];
}
