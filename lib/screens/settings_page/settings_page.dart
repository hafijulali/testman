import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../init.dart';
import '../../core/constants/app.dart';
import '../../core/constants/routes.dart';
import '../../core/constants/settings.dart';
import '../../custom/widgets/app_bar.dart';
import '../../utils/build_utils.dart';
import 'app_theme/app_theme.dart';
import 'export_database/export_database.dart';
import 'font_size/font_size.dart';
import 'import_database/import_database.dart';
import 'landing_page/landing_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SwitchListTile _useMaterial3(BuildContext context) {
    return SwitchListTile(
      title: const Text('Use Material 3'),
      value: useMaterial3,
      onChanged: (bool value) {
        setState(() {
          useMaterial3 = value;
          settingsDatabase!.put(material3SettingsKey, value);
        });
      },
      secondary: const Icon(Icons.design_services_outlined),
    );
  }

  SwitchListTile _showSubtitle(BuildContext context) {
    return SwitchListTile(
      title: const Text('Show subtitle in list items'),
      value: showSubtitle,
      onChanged: (bool value) {
        setState(() {
          showSubtitle = value;
          settingsDatabase!.put(showSubtitleKey, value);
        });
      },
      secondary: const Icon(Icons.subtitles_outlined),
    );
  }

  List<Widget> _widgetsTiles(BuildContext context) {
    return <Widget>[
      appTheme(context),
      const SizedBox(height: 16),
      _useMaterial3(context),
      const SizedBox(height: 16),
      // INFO : Removing the feature since, the subtitle is revealed
      // by tapping on the list item
      //_showSubtitle(context),
      // const SizedBox(height: 16),
      exportDatabase(context),
      const SizedBox(height: 16),
      importDatabase(context),
      const SizedBox(height: 16),
      landingPage(context),
      const SizedBox(height: 16),
      changeFontSize(context),
      const SizedBox(height: 16),
      _buildInfo(context)
    ];
  }

  Widget settingsPage(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: _widgetsTiles(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentPath = settingsPageRoute;
    return settingsPage(context);
  }

  ListTile _buildInfo(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.mobile_friendly_outlined),
      title: Text('App Version : ${getAppVersion()}'),
      onTap: () async => await launchUrlString(appCodebase),
    );
  }
}
