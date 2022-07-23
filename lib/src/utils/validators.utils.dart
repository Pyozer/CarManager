import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'regexp.util.dart';

class Validator {
  final BuildContext context;

  const Validator(this.context);

  String? noEmpty(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    return null;
  }

  String? emptyOrRegex(String? value, RegExpInfo regExpInfo) {
    if (value?.isEmpty ?? true) return null;
    if (regExpInfo.regexp.hasMatch(value!)) return null;
    return AppLocalizations.of(context)!.fieldMustMatch(regExpInfo.pattern);
  }

  String? isNumber(String? value) {
    final isEmptyCheck = noEmpty(value);
    if (isEmptyCheck != null) return isEmptyCheck;
    if (int.tryParse(value ?? '') == null) {
      return AppLocalizations.of(context)!.fieldMustBeNumber;
    }
    return null;
  }

  String? inRange(String? value, int from, [int to = 1000000]) {
    final isNumberCheck = isNumber(value);
    if (isNumberCheck != null) return isNumberCheck;
    if (int.parse(value!) < from || int.parse(value) > to) {
      return AppLocalizations.of(context)!.fieldMustBeBetween(from, to);
    }
    return null;
  }
}
