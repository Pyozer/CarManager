import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsThemeService {
  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('theme_mode');
    if (themeMode == 'light') return ThemeMode.light;
    if (themeMode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    String themeMode = 'system';
    if (theme == ThemeMode.light) themeMode = 'light';
    if (theme == ThemeMode.dark) themeMode = 'dark';
    await prefs.setString('theme_mode', themeMode);
  }
}
