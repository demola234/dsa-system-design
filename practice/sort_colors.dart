void sortColors(List<int> nums) {
  int low = 0;
  int high = nums.length - 1;
  int i = 0;

  while (i <= high) {
    if (nums[i] == 0) {
      final temp = nums[low];
      nums[low] = nums[i];
      nums[i] = temp;
      low++;
      i++;
    } else {
      if (nums[i] == 1) {
        i++;
      } else {
        final temp = nums[high];
        nums[high] = nums[i];
        nums[i] = temp;
        high--;
      }
    }
  }
}
