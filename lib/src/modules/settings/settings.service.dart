import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../car/model/car.model.dart';

class SettingsService {
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

  Future<List<Car>> carsSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final carsSaved = prefs.getStringList('cars_saved');

    if (carsSaved == null) return [];
    return carsSaved.map((car) => Car.fromJSON(jsonDecode(car))).toList();
  }

  Future<void> updateCarsSaved(List<Car> carsSaved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'cars_saved',
      carsSaved.map((car) => jsonEncode(car.toJSON())).toList(),
    );
  }
}
