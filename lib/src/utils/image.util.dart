import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

Future<Uint8List?> networkImageData(String imageUrl) async {
  try {
    final imageData = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
    return imageData.buffer.asUint8List();
  } catch (_) {}
  return null;
}

Future<String?> saveImageToStorage(
  String imageUrl,
  String path,
  int index,
) async {
  final storageRef = FirebaseStorage.instance.ref();

  final imageData = await networkImageData(imageUrl);
  if (imageData == null) return null;

  final imageName = '${index}_${const Uuid().v4()}';
  final imageRef = storageRef.child(path).child(imageName);

  try {
    await imageRef.putData(imageData);
    return await imageRef.getDownloadURL();
  } on FirebaseException catch (_) {}
  return null;
}
