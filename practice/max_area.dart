int maxArea(List<int> height) {
  var left = 0;
  var right = height.length - 1;
  var maxArea = 0;

  while (left < right) {
    final width = right - left;
    final minHeight =
        height[left] < height[right] ? height[left] : height[right];
    final area = width * minHeight;

    maxArea = maxArea > area ? maxArea : area;

    if (height[left] < height[right]) {
      left++;
    } else {
      right--;
    }
  }
  return maxArea;
}


