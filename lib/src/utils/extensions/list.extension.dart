extension IterableExtension<T> on Iterable<T> {
  List<E> mapList<E>(E Function(T e) toElement) {
    return map<E>(toElement).toList();
  }
}

extension ListExtension<T> on List<T> {
  List<T> superJoin(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];

    final list = [iterator.current];
    while (iterator.moveNext()) {
      list
        ..add(separator)
        ..add(iterator.current);
    }
    return list;
  }

  void move(int from, int to) {
    final element = removeAt(from);
    insert(to, element);
  }
}
