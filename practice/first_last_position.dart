List<int> searchRange(List<int> nums, int target) {
  final first = findFirst(nums, target);

  if (first == -1) {
    return [-1, -1];
  }

  final last = findLast(nums, target);
  return [first, last];
}

int findFirst(List<int> nums, int target) {
  var left = 0;
  var right = nums.length - 1;
  var result = -1;

  while (left <= right) {
    final mid = left + (right - left) ~/ 2;

    if (nums[mid] == target) {
      result = mid;
      right = mid - 1;
    } else if (nums[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return result;
}

int findLast(List<int> nums, int target) {
  var left = 0;
  var right = nums.length - 1;
  var result = -1;

  while (left <= right) {
    final mid = left + (right - left) ~/ 2;

    if (nums[mid] == target) {
      result = mid;
      left = mid + 1;
    } else if (nums[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return result;
}

main() {
  final nums = [1, 2, 2, 2, 2, 2, 3, 3, 4, 5];
  final target = 3;
  final result = searchRange(nums, target);
  print(result); 
}
