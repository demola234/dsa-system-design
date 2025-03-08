List<T> mergeSort<T extends Comparable>(List<T> array) {
  if (array.length <= 1) {
    return array;
  }

  final middle = array.length ~/ 2;
  final left = mergeSort(array.sublist(0, middle));
  final right = mergeSort(array.sublist(middle));

  return merge(left, right);
}

List<T> merge<T extends Comparable>(List<T> left, List<T> right) {
  final result = <T>[];
  var leftIndex = 0;
  var rightIndex = 0;

  while (leftIndex < left.length && rightIndex < right.length) {
    if (left[leftIndex].compareTo(right[rightIndex]) <= 0) {
      result.add(left[leftIndex]);
      leftIndex++;
    } else {
      result.add(right[rightIndex]);
      rightIndex++;
    }
  }

  result.addAll(left.sublist(leftIndex));
  result.addAll(right.sublist(rightIndex));

  return result;
}

main() {
  final array = List.generate(100, (index) => index);
  final shuffledArray = List.from(array);
  shuffledArray.shuffle();

  print(shuffledArray);
  final sortedArray = mergeSort(array);
  print(sortedArray);
}
