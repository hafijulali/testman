import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../custom/widgets/alert_dialog.dart';
import '../../../init.dart';
import '../../../utils/permissions_utils.dart';

ListTile importDatabase(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.sim_card_download_outlined),
    title: const Text('Import Database'),
    onTap: () => _import(context),
  );
}

Future<dynamic> _import(BuildContext context) async {
  try {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        checkAndroidStoragePermissions(context);
      }
      final FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        final Uint8List databaseBundleZip =
            File(result.files.single.path!).readAsBytesSync();
        final Archive databaseBundle =
            ZipDecoder().decodeBytes(databaseBundleZip);
        for (final file in databaseBundle) {
          final filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('${databaseDirectory?.path}/$filename')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory('out/$filename').create(recursive: true);
          }
        }
      } else {
        return;
      }
      if (!context.mounted) return null;
      await showAlertDialog(context, 'Database Imported Successully.', '');
    } else {}
  } on Exception catch (e) {
    if (!context.mounted) return null;
    await showAlertDialog(context, 'Database Import Failed !!!', 'Error: $e');
  }
}
