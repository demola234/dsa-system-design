void quickSort<T extends Comparable>(List<T> list, [int? start, int? end]) {
  start = start ?? 0;
  end = end ?? list.length - 1;

  if (start < end) {
    final pivot = partition(list, start, end);
    quickSort(list, start, pivot - 1);
    quickSort(list, pivot + 1, end);
  }
}

int partition<T extends Comparable>(List<T> list, int start, int end) {
  final pivot = list[end];
  var i = start - 1;

  for (var j = start; j < end; j++) {
    if (list[j].compareTo(pivot) <= 0) {
      i++;
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  final temp = list[i + 1];
  list[i + 1] = list[end];
  list[end] = temp;

  return i + 1;
}

void main(List<String> args) {
  final random = List.generate(1000, (index) => index);

  random.shuffle();

  quickSort(random);
  print(random);
}
