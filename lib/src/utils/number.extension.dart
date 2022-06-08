extension NumberParsing on int {
  String toStringLeading([int leadingZero = 2]) {
    return toString().padLeft(leadingZero, '0');
  }
}