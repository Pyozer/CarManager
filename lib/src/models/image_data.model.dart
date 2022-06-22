import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ImageData<T> {
  T data;

  ImageData(this.data);

  String get key;
}

class ImageFile extends ImageData<XFile> {
  ImageFile(super.data);

  File get file => File(data.path);

  @override
  String get key => data.path;
}

class ImageURL extends ImageData<String> {
  ImageURL(super.data);

  @override
  String get key => data;
}
