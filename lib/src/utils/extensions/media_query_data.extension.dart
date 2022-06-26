import 'package:flutter/material.dart';

extension MediaQueryDataExt on MediaQueryData {
  double get paddingAboveFAB {
    return padding.bottom + 56.0 + 24.0;
  }
}
