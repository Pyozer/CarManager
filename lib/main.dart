import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/modules/settings/settings_cars.controller.dart';
import 'src/modules/settings/settings_theme.controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settingsThemeController = SettingsThemeController();
  await settingsThemeController.load();

  final settingsCarsController = SettingsCarsController();
  await settingsCarsController.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsThemeController>.value(
          value: settingsThemeController,
        ),
        ChangeNotifierProvider<SettingsCarsController>.value(
          value: settingsCarsController,
        ),
      ],
      child: const MyApp(),
    ),
  );
}
