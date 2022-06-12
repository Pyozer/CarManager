import 'package:flutter/material.dart';

import 'regexp.util.dart';

class Validator {
  final BuildContext context;

  const Validator(this.context);

  String? noEmpty(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Field required';
    return null;
  }

  String? emptyOrRegex(String? value, RegExpInfo regExpInfo) {
    if (value?.isEmpty ?? true) return null;
    if (regExpInfo.regexp.hasMatch(value!)) return null;
    return 'Field must match like this ${regExpInfo.pattern}';
  }

  String? isNumber(String? value) {
    final isEmptyCheck = noEmpty(value);
    if (isEmptyCheck != null) return isEmptyCheck;
    if (int.tryParse(value ?? '') == null) return 'Field must be a number';
    return null;
  }

  String? inRange(String? value, int from, [int to = 1000000]) {
    final isNumberCheck = isNumber(value);
    if (isNumberCheck != null) return isNumberCheck;
    if (int.parse(value!) < from || int.parse(value) > to) {
      return 'Field must be between $from and $to';
    }
    return null;
  }
}
