import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../../core/constants/app.dart';
import '../../../custom/widgets/alert_dialog.dart';
import '../../../init.dart';
import '../../../utils/permissions_utils.dart';

ListTile exportDatabase(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.upload_file_outlined),
    title: const Text('Export Database'),
    onTap: () async => _export(context),
  );
}

Future<dynamic> _export(BuildContext context) async {
  try {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        checkAndroidStoragePermissions(context);
      }
      final String? exportDirectory =
          await FilePicker.platform.getDirectoryPath();
      if (exportDirectory != null) {
        final ZipFileEncoder encoder = ZipFileEncoder();
        encoder.zipDirectory(
          databaseDirectory!,
          filename: path.join(exportDirectory, '${appName}Export.zip'),
          onProgress: (percent) => showAlertDialog(
            context,
            'Export in progress',
            'Current progress $percent%',
          ),
        );

        if (!context.mounted) return;
        await showAlertDialog(
          context,
          'Database Exported Successully',
          'Path: $exportDirectory',
        );
      } else {
        if (!context.mounted) return null;
      }
    } else {
      if (!context.mounted) return null;
    }
  } on Exception catch (e) {
    if (!context.mounted) return null;
    await showAlertDialog(context, 'Database Export Failed !!!', 'Error: $e');
  }
}
