List<int> twoSums(List<int> nums, int target) {
  final map = <int, int>{};
  final result = <int>[];

  for (var i = 0; i < nums.length; i++) {
    final complement = target - nums[i];
    if (map.containsKey(complement)) {
      return [map[complement]!, i];
    } else {
      result.add(nums[i]);
      map[nums[i]] = i;
    }
  }

  return [];
}

main(List<String> args) {
  print(twoSums([2, 7, 11, 15], 9));

  print(twoSums([3, 2, 4], 6));

  print(twoSums([3, 3], 6));

  print(twoSums([3, 2, 3], 6));
}
