import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/constants/strings.dart';
import '../custom/widgets/snack_bar.dart';
import '../init.dart';

Future<void> checkAndroidStoragePermissions(BuildContext context) async {
  permission ??= await Permission.manageExternalStorage.request();
  if (permission!.isDenied) {
    await showSnackbar(writePermissionDenied);
  }
}
