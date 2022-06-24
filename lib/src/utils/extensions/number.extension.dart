extension NumberParsing on int {
  String toStringLeading([int leadingZero = 2]) {
    return toString().padLeft(leadingZero, '0');
  }

  int roundToUpperMultiple(int multiple) {
    return (this / multiple).ceil() * multiple;
  }
}
