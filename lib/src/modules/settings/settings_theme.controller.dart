import 'package:flutter/material.dart';

import 'services/settings_theme.service.dart';
import 'settings.controller.dart';

class SettingsThemeController extends SettingsController<SettingsThemeService> {
  SettingsThemeController() : super(SettingsThemeService());

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  @override
  Future<void> load() async {
    _themeMode = await service.themeMode();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();

    await service.updateThemeMode(newThemeMode);
    await load();
  }
}
