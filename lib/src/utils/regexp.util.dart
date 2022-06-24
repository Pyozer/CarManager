class RegExpInfo {
  late final RegExp regexp;
  final String pattern;

  RegExpInfo(this.regexp, this.pattern);
}

// Match car plate like AA-123-BB or 1234-AA-56
final carPlateRegExp = RegExpInfo(
  RegExp(
    r'^(([A-Za-z]{2}-[0-9]{3}-[A-Za-z]{2})|([0-9]{4}-[A-Za-z]{2}-[0-9]{2}))$',
  ),
  'AA-123-BB / 1234-AA-56',
);

// Match car VIN number
final carVINRegExp = RegExpInfo(
  RegExp(r'^[(A-H|J-N|P|R-Z|0-9)]{17}$'),
  'WBSBL910X0JP84144',
);
