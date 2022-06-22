import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

Future<Uint8List> networkImageData(String imageUrl) async {
  final imageBytes = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
  return imageBytes.buffer.asUint8List();
}

Future<String> saveToStorage(Uint8List data, String path, int index) async {
  final imageName = '${index}_${const Uuid().v4()}';
  final imageRef = FirebaseStorage.instance.ref().child(path).child(imageName);

  await imageRef.putData(data);
  return imageRef.getDownloadURL();
}

Future<void> deleteAllFromStorage(String path) async {
  final storageRef = FirebaseStorage.instance.ref();
  final files = await storageRef.child(path).listAll();

  await Future.wait(
    files.items.map((e) => storageRef.child(e.fullPath).delete()),
  ).catchError((_) => _);
}
