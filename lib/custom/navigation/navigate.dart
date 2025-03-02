import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../../init.dart';

Future<void> safePop(BuildContext context) async {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}

Future<String?> safePopWithResult(BuildContext context, String result) async {
  if (Navigator.canPop(context)) {
    Navigator.pop(context, result);
  }
  return none;
}

void safePush(BuildContext context, String route) {
  if (currentPath != route) {
    Navigator.pushNamed(context, route);
  }
}
