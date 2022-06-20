import 'package:flutter/material.dart';

import '../../utils/data.util.dart';
import '../car/model/car.model.dart';
import 'settings.service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this.settingsService);

  final SettingsService settingsService;

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  late List<Car> _carsSaved;
  List<Car> get carsSaved => _carsSaved;

  Future<void> loadSettings() async {
    // TODO; Remove
    // for (var car in carsSavedData) {
    //   await settingsService.addCar(car);
    // }

    _themeMode = await settingsService.themeMode();
    _carsSaved = await settingsService.getCars();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;

    notifyListeners();
    await settingsService.updateThemeMode(newThemeMode);
  }

  Future<String> addCar(Car newCar) {
    _carsSaved.add(newCar);

    notifyListeners();
    return settingsService.addCar(newCar);
  }

  Future<void> updateCar(Car updatedCar) async {
    final index = _carsSaved.indexWhere((car) => car.uuid == updatedCar.uuid);
    _carsSaved[index] = updatedCar;

    notifyListeners();
    await settingsService.updateCar(updatedCar);
  }
}
