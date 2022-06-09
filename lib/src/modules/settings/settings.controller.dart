import 'package:car_manager/src/utils/data.util.dart';
import 'package:flutter/material.dart';

import '../car/model/car.model.dart';
import 'settings.service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;


  late List<Car> _carsSaved;
  List<Car> get carsSaved => _carsSaved;

  Future<void> loadSettings() async {
    // TODO; Remove
    await _settingsService.updateCarsSaved(carsSavedData);
  
    _themeMode = await _settingsService.themeMode();
    _carsSaved = await _settingsService.carsSaved();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
  
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> addCar(Car newCar) async {
    _carsSaved.add(newCar);
  
    notifyListeners();
    await _settingsService.updateCarsSaved(_carsSaved);
  }

  Future<void> updateCarsSaved(List<Car>? newCarsSaved) async {
    if (newCarsSaved == null) return;
    _carsSaved = newCarsSaved;
  
    notifyListeners();
    await _settingsService.updateCarsSaved(newCarsSaved);
  }
}
