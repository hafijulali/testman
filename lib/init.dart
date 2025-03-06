import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/network/apiclient.dart';
import 'package:timezone/data/latest_all.dart' as tz_latest;
import 'package:timezone/timezone.dart' as tz;

import 'core/constants/app.dart';
import 'core/constants/routes.dart';
import 'core/constants/settings.dart';
import 'screens/add_request_page/add_request_page.dart';
import 'screens/collections_page/collections_page.dart';
import 'screens/history_page/history_page.dart';
import 'screens/home_page/home_page.dart';
import 'screens/settings_page/settings_page.dart';
import 'storage/models/request_model.dart';

Box<Request>? historyDatabase;
Box<Request>? collectionsDatabase;
Box<dynamic>? settingsDatabase;
PermissionStatus? permission;
String? historyDatabaseFilePath;
String? collectionsDatabaseFilePath;
String? settingsDatabaseFilePath;
Directory? databaseDirectory;

// INFO : Primarily used to navigate widget tree from MaterialApp
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
TextEditingController searchTextController = TextEditingController();
TextEditingController apiKeyTextController = TextEditingController();

ApiClient apiClient = ApiClient();
bool showSubtitle = settingsDatabase?.get(showSubtitleKey, defaultValue: true);
int currentPageIndex =
    settingsDatabase?.get(landingPageSettingsKey, defaultValue: 0);
String currentPath = homePageRoute;
PageController pageController = PageController(initialPage: currentPageIndex);
ThemeMode appThemeMode =
    settingsDatabase?.get(appThemeSettingsKey, defaultValue: ThemeMode.system);
bool useMaterial3 =
    settingsDatabase?.get(material3SettingsKey, defaultValue: true);
double fontSize =
    settingsDatabase?.get(fontSizeSettingsKey, defaultValue: 30.0);

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  historyPageRoute: (_) => const HistoryPage(),
  addRequestPageRoute: (_) => const AddRequestPage(),
  collectionsPageRoute: (_) => const CollectionsPage(),
  homePageRoute: (_) => const HomePage(),
  settingsPageRoute: (_) => const SettingsPage(),
  editRequestPageRoute: (_) => AddRequestPage(
        database: historyDatabase,
        index:
            0, // INFO : setting index to dummy value so that navigator for EditRequestPage works correctly
      ),
};

Map<String, Widget> tabs = <String, Widget>{
  historyPageRoute: const HistoryPage(),
  addRequestPageRoute: const AddRequestPage(),
  collectionsPageRoute: const CollectionsPage(),
};

Future<void> initApp() async {
  await _initServices();
  await _initDatabase();
  await _initCloud();
}

Future<void> _initCloud() async {}

Future<void> _initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(RequestAdapter());

  if (!kIsWeb) {
    tz_latest.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  }
}

Future<void> _initDatabase() async {
  await Hive.initFlutter(appName);

  settingsDatabase = await Hive.openBox<dynamic>(settingsDatabaseFileName);
  historyDatabase = await Hive.openBox<Request>(historyDatabaseFileName);
  collectionsDatabase =
      await Hive.openBox<Request>(collectionsDatabaseFileName);
  historyDatabaseFilePath = historyDatabase!.path.toString();
  collectionsDatabaseFilePath = collectionsDatabase!.path.toString();
  settingsDatabaseFilePath = settingsDatabase!.path.toString();

  if (!kIsWeb) {
    databaseDirectory = Directory(historyDatabaseFilePath!).parent;
  }
}

ThemeData getTheme() {
  if (ThemeMode.system == ThemeMode.dark) {
    return ThemeData.dark(useMaterial3: useMaterial3);
  }
  return ThemeData.light(useMaterial3: useMaterial3);
}
