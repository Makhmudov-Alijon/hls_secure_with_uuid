extension ListDynamicX<T> on List<T> {
  bool hasItem(int index) {
    return index <= length - 1;
  }

  bool canIterateNext(int currentIndex) {
    return hasItem(currentIndex + 1);
  }

  bool canIteratePrevious(int currentIndex) {
    return hasItem(currentIndex - 1);
  }

  Iterable<T> safeGetLimit(int i, int limit) {
    if (i < 0 || i >= length) {
      // If the start index is out of bounds, return an empty list
      return [];
    }

    // Calculate the end index, ensuring it doesn't exceed the list length
    final end = (i + limit > length) ? length : i + limit;

    return getRange(i, end);
  }
}
