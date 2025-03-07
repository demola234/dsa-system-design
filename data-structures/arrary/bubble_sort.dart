void bubbleSort<T extends Comparable>(List<T> nums) {
  final n = nums.length;

  for (var i = 0; i < n; i++) {
    bool swapped = false;

    for (var j = 0; j < n - i - 1; j++) {
      if (nums[j].compareTo(nums[j + 1]) > 0) {
        var temp = nums[j];
        nums[j] = nums[j + 1];
        nums[j + 1] = temp;
        swapped = true;
      }
    }

    if (!swapped) {
      break;
    }
  }
}

void main(List<String> args) {
  final random = List.generate(1000, (index) => index);

  random.shuffle();
  bubbleSort(random);
  print(random);
}
