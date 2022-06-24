import 'package:flutter/material.dart';

abstract class SettingsController<T> with ChangeNotifier {
  final T service;

  SettingsController(this.service);

  Future<void> load();
}
