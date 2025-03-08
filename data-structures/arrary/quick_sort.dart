void quickSort<T extends Comparable>(List array, [int? start, int? end]) {
  start = start ?? 0;
  end = end ?? array.length - 1;

  if (start < end) {
    final pivotIndex = partition(array, start, end);
    quickSort(array, start, pivotIndex - 1);
    quickSort(array, pivotIndex + 1, end);
  }
}

int partition<T extends Comparable>(List array, int start, int end) {
  final pivot = array[end];
  var i = start - 1;

  for (var j = start; j < end; j++) {
    if (array[j].compareTo(pivot) <= 0) {
      i++;

      final temp = array[j];
      array[j] = array[i];
      array[i] = temp;
    }
  }

  final temp = array[i + 1];
  array[i + 1] = array[end];
  array[end] = temp;

  return i + 1;
}

void main(List<String> args) {
  var random = List.generate(100, (index) => index);

  random.shuffle();
  print(random);

  quickSort(random);
  print(random);
}
