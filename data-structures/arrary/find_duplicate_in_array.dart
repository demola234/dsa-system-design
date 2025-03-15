int removeDuplicates(List<int> nums) {
  if (nums.isEmpty) return 0;

  var i = 0;
  for (var j = 1; j < nums.length; j++) {
    if (nums[i] != nums[j]) {
      i++;
      nums[i] = nums[j];
    } else {
      nums[i] = nums[j];
    }

    return i + 1;
  }

  return i + 1;
}

main() {
  final nums = [1, 2, 2, 3, 4, 5, 5, 6];
  print(removeDuplicates(nums));
}
