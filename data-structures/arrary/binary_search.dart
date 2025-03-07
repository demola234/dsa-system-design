int binarySearch<T extends Comparable>(List<T> list, T target) {
  int left = 0;
  int right = list.length - 1;

  while (left <= right) {
    final mid = left + (right - left) ~/ 2;

    if (list[mid] == target) {
      return mid;
    }

    if (list[mid].compareTo(target) < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return -1;
}
