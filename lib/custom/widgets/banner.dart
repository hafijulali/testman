import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../init.dart';

Future<void> showMaterialBanner(String text, [List<Widget>? actions]) async {
  if (rootScaffoldMessengerKey.currentState != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) => rootScaffoldMessengerKey
        .currentState
        ?.showMaterialBanner(MaterialBanner(
            content: Text(ok),
            actions: actions ??
                [
                  IconButton.outlined(
                      onPressed: () => {},
                      icon: Icon(Icons.notification_add_outlined))
                ])));
  }
}
