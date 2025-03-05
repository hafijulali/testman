import 'package:flutter/material.dart';

import '../../../core/constants/app.dart';
import '../../../core/constants/settings.dart';
import '../../../init.dart';

List<DropdownMenuEntry> _dropdownMenuEntries() {
  final List<String> themes = <String>[
    'System Theme',
    'Light Theme',
    'Dark Theme'
  ];
  final List<DropdownMenuEntry> menuItems = List.empty(growable: true);
  for (final String element in themes) {
    menuItems.add(
      DropdownMenuEntry(
        value: element,
        label: element,
      ),
    );
  }
  return menuItems;
}

ListTile appTheme(BuildContext context) {
  return ListTile(
    leading: const Icon(Icons.font_download_outlined),
    title: const Text('App Theme'),
    subtitle: const Text('Theme to use across app'),
    trailing: SizedBox(
      width: settingsTileWidgetWidth,
      child: DropdownMenu<dynamic>(
        hintText: appThemeMode.toString(),
        dropdownMenuEntries: _dropdownMenuEntries(),
        onSelected: (value) {
          appThemeMode = value;
          settingsDatabase!.put(appThemeSettingsKey, value);
        },
      ),
    ),
  );
}
