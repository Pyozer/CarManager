import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  CollectionReference<Car> _getCarRef() {
    return FirebaseFirestore.instance.collection('cars').withConverter<Car>(
          fromFirestore: (snapshot, _) => Car.fromJson(snapshot.data()!),
          toFirestore: (car, _) => car.toJson(),
        );
  }

  Future<String?> _getCarDocumentId(String carUUID) async {
    final snap =
        await _getCarRef().where('uuid', isEqualTo: carUUID).limit(1).get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.id;
  }

  Future<List<Car>> getCars() async {
    final data = await _getCarRef().get();
    return data.docs.map((doc) => doc.data()).toList();
  }

  Future<String> addCar(Car car) async {
    final carAdded = await _getCarRef().add(car);
    return carAdded.id;
  }

  Future<void> updateCar(Car car) async {
    final carDocId = await _getCarDocumentId(car.uuid);
    if (carDocId == null) return;

    await _getCarRef().doc(carDocId).update(car.toJson());
  }
}
