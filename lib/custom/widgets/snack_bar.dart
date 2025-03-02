import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../init.dart';

SnackBar getSnackBar(String text, SnackBarAction action) {
  return SnackBar(
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      showCloseIcon: true,
      action: action);
}

Future<void> showSnackbar(String text, [SnackBarAction? action]) async {
  if (rootScaffoldMessengerKey.currentState != null) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => rootScaffoldMessengerKey.currentState?.showSnackBar(getSnackBar(
            text,
            action ??
                SnackBarAction(
                  label: undo,
                  onPressed: () => {},
                ))));
  }
}
