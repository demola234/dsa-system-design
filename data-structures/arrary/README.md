# Arrays

Arrays (implemented as `List<T>` in Dart) are one of the most fundamental data structures in computer science. This guide will help you master arrays and common array problems through practical Dart implementations.

## Table of Contents
- [Array Basics](#array-basics)
- [Array Operations](#array-operations)
- [Common Array Problems](#common-array-problems)
  - [Searching](#searching)
  - [Sorting](#sorting)
  - [Two Pointers](#two-pointers)
  - [Sliding Window](#sliding-window)
  - [Prefix Sums](#prefix-sums)
  - [Kadane's Algorithm](#kadanes-algorithm)
  - [Matrix Operations](#matrix-operations)
- [Advanced Array Techniques](#advanced-array-techniques)

## Array Basics

In Dart, arrays are implemented as `List<T>` objects. There are two types of lists:
- Fixed-length lists
- Growable lists

### Creating Arrays in Dart

```dart
// Fixed-length list
final fixedArray = List<int>.filled(5, 0);  // [0, 0, 0, 0, 0]

// Growable list
final growableArray = <int>[];  // []
final initializedArray = <int>[1, 2, 3, 4, 5];  // [1, 2, 3, 4, 5]

// Creating using List.generate
final generatedArray = List<int>.generate(5, (index) => index * 2);  // [0, 2, 4, 6, 8]

// Creating from another iterable
final fromIterable = List<int>.from([1, 2, 3]);  // [1, 2, 3]

// Unmodifiable list
final unmodifiableList = List.unmodifiable([1, 2, 3]);  // Cannot be modified after creation
```

### Array Properties

```dart
final array = [1, 2, 3, 4, 5];

// Length
print(array.length);  // 5

// Is empty
print(array.isEmpty);  // false
print(array.isNotEmpty);  // true

// First and last elements
print(array.first);  // 1
print(array.last);  // 5

// Reversed view
print(array.reversed);  // (5, 4, 3, 2, 1)
```

## Array Operations

### Basic Operations

```dart
final list = <int>[1, 2, 3];

// Adding elements
list.add(4);  // [1, 2, 3, 4]
list.addAll([5, 6]);  // [1, 2, 3, 4, 5, 6]
list.insert(1, 99);  // [1, 99, 2, 3, 4, 5, 6]
list.insertAll(2, [100, 101]);  // [1, 99, 100, 101, 2, 3, 4, 5, 6]

// Removing elements
list.remove(99);  // Removes the first occurrence of 99
list.removeAt(0);  // Removes element at index 0
list.removeLast();  // Removes the last element
list.removeWhere((element) => element > 100);  // Removes all elements matching the condition
list.clear();  // Removes all elements
```

### Finding Elements

```dart
final numbers = [10, 20, 30, 40, 50, 30];

// Checking existence
print(numbers.contains(30));  // true

// Finding index
print(numbers.indexOf(30));  // 2 (first occurrence)
print(numbers.lastIndexOf(30));  // 5 (last occurrence)
print(numbers.indexWhere((element) => element > 25));  // 2

// Filtering
final greaterThan25 = numbers.where((element) => element > 25).toList();  // [30, 40, 50, 30]
```

### Transforming Arrays

```dart
final numbers = [1, 2, 3, 4, 5];

// Map
final doubled = numbers.map((e) => e * 2).toList();  // [2, 4, 6, 8, 10]

// Fold/Reduce
final sum = numbers.fold(0, (prev, element) => prev + element);  // 15
final product = numbers.reduce((value, element) => value * element);  // 120

// Expand (FlatMap)
final nested = [[1, 2], [3, 4], [5]];
final flattened = nested.expand((element) => element).toList();  // [1, 2, 3, 4, 5]
```

### Slicing and Joining

```dart
final list = [1, 2, 3, 4, 5];

// Sublist
final middle = list.sublist(1, 4);  // [2, 3, 4]

// Join
final joined = list.join(', ');  // "1, 2, 3, 4, 5"
```

## Common Array Problems

### Searching

#### Linear Search

Time Complexity: O(n)

```dart
int linearSearch<T>(List<T> array, T target) {
  for (var i = 0; i < array.length; i++) {
    if (array[i] == target) {
      return i;
    }
  }
  return -1;  // Not found
}
```

#### Binary Search (for sorted arrays)

Time Complexity: O(log n)

```dart
int binarySearch<T extends Comparable<T>>(List<T> array, T target) {
  var left = 0;
  var right = array.length - 1;
  
  while (left <= right) {
    final mid = left + (right - left) ~/ 2;
    
    if (array[mid] == target) {
      return mid;
    }
    
    if (array[mid].compareTo(target) < 0) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  return -1;  // Not found
}
```

#### Problem: Find First and Last Position of Element in Sorted Array

```dart
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
      right = mid - 1;  // Continue searching on the left
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
      left = mid + 1;  // Continue searching on the right
    } else if (nums[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  return result;
}
```

### Sorting

#### Bubble Sort

Time Complexity: O(n²)

```dart
void bubbleSort<T extends Comparable<T>>(List<T> array) {
  final n = array.length;
  
  for (var i = 0; i < n; i++) {
    var swapped = false;
    
    for (var j = 0; j < n - i - 1; j++) {
      if (array[j].compareTo(array[j + 1]) > 0) {
        // Swap elements
        final temp = array[j];
        array[j] = array[j + 1];
        array[j + 1] = temp;
        swapped = true;
      }
    }
    
    // If no swapping occurred in this pass, array is sorted
    if (!swapped) break;
  }
}
```

#### Quick Sort

Time Complexity: O(n log n) average, O(n²) worst

```dart
void quickSort<T extends Comparable<T>>(List<T> array, [int? start, int? end]) {
  start = start ?? 0;
  end = end ?? array.length - 1;
  
  if (start < end) {
    final pivotIndex = partition(array, start, end);
    quickSort(array, start, pivotIndex - 1);
    quickSort(array, pivotIndex + 1, end);
  }
}

int partition<T extends Comparable<T>>(List<T> array, int start, int end) {
  final pivot = array[end];
  var i = start - 1;
  
  for (var j = start; j < end; j++) {
    if (array[j].compareTo(pivot) <= 0) {
      i++;
      // Swap array[i] and array[j]
      final temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
  }
  
  // Swap array[i+1] and array[end] (pivot)
  final temp = array[i + 1];
  array[i + 1] = array[end];
  array[end] = temp;
  
  return i + 1;
}
```

#### Merge Sort

Time Complexity: O(n log n)

```dart
List<T> mergeSort<T extends Comparable<T>>(List<T> array) {
  if (array.length <= 1) {
    return array;
  }
  
  final middle = array.length ~/ 2;
  final left = mergeSort(array.sublist(0, middle));
  final right = mergeSort(array.sublist(middle));
  
  return merge(left, right);
}

List<T> merge<T extends Comparable<T>>(List<T> left, List<T> right) {
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
  
  // Add remaining elements
  result.addAll(left.sublist(leftIndex));
  result.addAll(right.sublist(rightIndex));
  
  return result;
}
```

#### Problem: Sort Colors (Dutch National Flag Problem)

```dart
void sortColors(List<int> nums) {
  var low = 0;
  var mid = 0;
  var high = nums.length - 1;
  
  while (mid <= high) {
    if (nums[mid] == 0) {
      // Swap nums[low] and nums[mid]
      final temp = nums[low];
      nums[low] = nums[mid];
      nums[mid] = temp;
      low++;
      mid++;
    } else if (nums[mid] == 1) {
      mid++;
    } else {  // nums[mid] == 2
      // Swap nums[mid] and nums[high]
      final temp = nums[mid];
      nums[mid] = nums[high];
      nums[high] = temp;
      high--;
    }
  }
}
```

### Two Pointers

#### Problem: Two Sum (Find pair with given sum)

```dart
List<int> twoSum(List<int> nums, int target) {
  final map = <int, int>{};
  
  for (var i = 0; i < nums.length; i++) {
    final complement = target - nums[i];
    
    if (map.containsKey(complement)) {
      return [map[complement]!, i];
    }
    
    map[nums[i]] = i;
  }
  
  return [];  // No solution found
}
```

#### Problem: Container With Most Water

```dart
int maxArea(List<int> height) {
  var left = 0;
  var right = height.length - 1;
  var maxArea = 0;
  
  while (left < right) {
    final width = right - left;
    final minHeight = height[left] < height[right] ? height[left] : height[right];
    final area = width * minHeight;
    
    maxArea = area > maxArea ? area : maxArea;
    
    if (height[left] < height[right]) {
      left++;
    } else {
      right--;
    }
  }
  
  return maxArea;
}
```

#### Problem: Remove Duplicates from Sorted Array

```dart
int removeDuplicates(List<int> nums) {
  if (nums.isEmpty) return 0;
  
  var i = 0;
  
  for (var j = 1; j < nums.length; j++) {
    if (nums[j] != nums[i]) {
      i++;
      nums[i] = nums[j];
    }
  }
  
  return i + 1;  // Length of array with duplicates removed
}
```

### Sliding Window

#### Problem: Maximum Subarray Sum of Size K

```dart
int maxSubArraySum(List<int> nums, int k) {
 int n = nums.length;
    if (k > n) return 0;

    int maxSum = 0, currentSum = 0, start = 0;
    Set<int> seen = {};

    for (int end = 0; end < n; end++) {
      while (seen.contains(nums[end]) || seen.length >= k) {
        currentSum -= nums[start];
        seen.remove(nums[start]);
        start++;
      }

      seen.add(nums[end]);
      currentSum += nums[end];

      if (seen.length == k) {
        maxSum = maxSum > currentSum ? maxSum : currentSum;
      }
    }
    return maxSum;
}
```

#### Problem: Longest Substring Without Repeating Characters

```dart
int lengthOfLongestSubstring(String s) {
  var maxLength = 0;
  final charIndex = <String, int>{};
  var left = 0;
  
  for (var right = 0; right < s.length; right++) {
    final currentChar = s[right];
    
    if (charIndex.containsKey(currentChar) && charIndex[currentChar]! >= left) {
      left = charIndex[currentChar]! + 1;
    }
    
    charIndex[currentChar] = right;
    maxLength = (right - left + 1) > maxLength ? (right - left + 1) : maxLength;
  }
  
  return maxLength;
}
```

### Prefix Sums

#### Problem: Range Sum Query - Immutable

```dart
class NumArray {
  final List<int> prefixSum;
  
  NumArray(List<int> nums)
      : prefixSum = List<int>.filled(nums.length + 1, 0) {
    for (var i = 0; i < nums.length; i++) {
      prefixSum[i + 1] = prefixSum[i] + nums[i];
    }
  }
  
  int sumRange(int left, int right) {
    return prefixSum[right + 1] - prefixSum[left];
  }
}
```

#### Problem: Subarray Sum Equals K

```dart
int subarraySum(List<int> nums, int k) {
  final map = <int, int>{0: 1};  // Map prefix sum to its frequency
  var sum = 0;
  var count = 0;
  
  for (final num in nums) {
    sum += num;
    
    if (map.containsKey(sum - k)) {
      count += map[sum - k]!;
    }
    
    map[sum] = (map[sum] ?? 0) + 1;
  }
  
  return count;
}
```

### Kadane's Algorithm

#### Problem: Maximum Subarray

```dart
int maxSubArray(List<int> nums) {
  if (nums.isEmpty) return 0;
  
  var maxEndingHere = nums[0];
  var maxSoFar = nums[0];
  
  for (var i = 1; i < nums.length; i++) {
    maxEndingHere = nums[i] > maxEndingHere + nums[i] ? nums[i] : maxEndingHere + nums[i];
    maxSoFar = maxEndingHere > maxSoFar ? maxEndingHere : maxSoFar;
  }
  
  return maxSoFar;
}
```

#### Problem: Maximum Circular Subarray Sum

```dart
int maxSubarraySumCircular(List<int> nums) {
  if (nums.isEmpty) return 0;
  
  // Case 1: Maximum subarray sum using Kadane's algorithm
  var maxEndingHere = nums[0];
  var maxSoFar = nums[0];
  var sum = nums[0];
  
  for (var i = 1; i < nums.length; i++) {
    sum += nums[i];
    maxEndingHere = nums[i] > maxEndingHere + nums[i] ? nums[i] : maxEndingHere + nums[i];
    maxSoFar = maxEndingHere > maxSoFar ? maxEndingHere : maxSoFar;
  }
  
  // Case 2: Maximum subarray sum with circular wrapping
  var minEndingHere = nums[0];
  var minSoFar = nums[0];
  
  for (var i = 1; i < nums.length; i++) {
    minEndingHere = nums[i] < minEndingHere + nums[i] ? nums[i] : minEndingHere + nums[i];
    minSoFar = minEndingHere < minSoFar ? minEndingHere : minSoFar;
  }
  
  final circularSum = sum - minSoFar;
  
  // If all numbers are negative, return the maximum number
  if (circularSum == 0) {
    return maxSoFar;
  }
  
  return maxSoFar > circularSum ? maxSoFar : circularSum;
}
```

### Matrix Operations

#### Problem: Rotate Image (Matrix)

```dart
void rotate(List<List<int>> matrix) {
  final n = matrix.length;
  
  // Transpose the matrix
  for (var i = 0; i < n; i++) {
    for (var j = i; j < n; j++) {
      final temp = matrix[i][j];
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = temp;
    }
  }
  
  // Reverse each row
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n ~/ 2; j++) {
      final temp = matrix[i][j];
      matrix[i][j] = matrix[i][n - j - 1];
      matrix[i][n - j - 1] = temp;
    }
  }
}
```

#### Problem: Spiral Matrix

```dart
List<int> spiralOrder(List<List<int>> matrix) {
  final result = <int>[];
  
  if (matrix.isEmpty) return result;
  
  var top = 0;
  var bottom = matrix.length - 1;
  var left = 0;
  var right = matrix[0].length - 1;
  
  while (top <= bottom && left <= right) {
    // Traverse right
    for (var j = left; j <= right; j++) {
      result.add(matrix[top][j]);
    }
    top++;
    
    // Traverse down
    for (var i = top; i <= bottom; i++) {
      result.add(matrix[i][right]);
    }
    right--;
    
    if (top <= bottom) {
      // Traverse left
      for (var j = right; j >= left; j--) {
        result.add(matrix[bottom][j]);
      }
      bottom--;
    }
    
    if (left <= right) {
      // Traverse up
      for (var i = bottom; i >= top; i--) {
        result.add(matrix[i][left]);
      }
      left++;
    }
  }
  
  return result;
}
```

## Advanced Array Techniques

### Problem: Next Permutation

```dart
void nextPermutation(List<int> nums) {
  var i = nums.length - 2;
  
  // Find the first decreasing element from the right
  while (i >= 0 && nums[i] >= nums[i + 1]) {
    i--;
  }
  
  if (i >= 0) {
    var j = nums.length - 1;
    
    // Find the element just larger than nums[i]
    while (nums[j] <= nums[i]) {
      j--;
    }
    
    // Swap them
    swap(nums, i, j);
  }
  
  // Reverse the subarray after position i
  reverse(nums, i + 1, nums.length - 1);
}

void swap(List<int> nums, int i, int j) {
  final temp = nums[i];
  nums[i] = nums[j];
  nums[j] = temp;
}

void reverse(List<int> nums, int start, int end) {
  while (start < end) {
    swap(nums, start, end);
    start++;
    end--;
  }
}
```

### Problem: Trapping Rain Water

```dart
int trap(List<int> height) {
  if (height.isEmpty) return 0;
  
  var left = 0;
  var right = height.length - 1;
  var leftMax = 0;
  var rightMax = 0;
  var result = 0;
  
  while (left < right) {
    if (height[left] < height[right]) {
      if (height[left] >= leftMax) {
        leftMax = height[left];
      } else {
        result += leftMax - height[left];
      }
      left++;
    } else {
      if (height[right] >= rightMax) {
        rightMax = height[right];
      } else {
        result += rightMax - height[right];
      }
      right--;
    }
  }
  
  return result;
}
```

### Problem: Longest Consecutive Sequence

```dart
int longestConsecutive(List<int> nums) {
  if (nums.isEmpty) return 0;
  
  final numSet = nums.toSet();
  var longestStreak = 0;
  
  for (final num in numSet) {
    // Only start a streak from its beginning
    if (!numSet.contains(num - 1)) {
      var currentNum = num;
      var currentStreak = 1;
      
      while (numSet.contains(currentNum + 1)) {
        currentNum++;
        currentStreak++;
      }
      
      longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
    }
  }
  
  return longestStreak;
}
```

### Problem: Merge Intervals

```dart
List<List<int>> merge(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];
  
  // Sort intervals by start time
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  
  final merged = <List<int>>[];
  merged.add(List.from(intervals[0]));
  
  for (var i = 1; i < intervals.length; i++) {
    final current = intervals[i];
    final previous = merged.last;
    
    if (current[0] <= previous[1]) {
      // Overlapping intervals, update the end time of the previous interval
      previous[1] = current[1] > previous[1] ? current[1] : previous[1];
    } else {
      // Non-overlapping interval, add to result
      merged.add(List.from(current));
    }
  }
  
  return merged;
}
```

### Problem: 3Sum

```dart
List<List<int>> threeSum(List<int> nums) {
  final result = <List<int>>[];
  
  if (nums.length < 3) return result;
  
  nums.sort();
  
  for (var i = 0; i < nums.length - 2; i++) {
    // Skip duplicates
    if (i > 0 && nums[i] == nums[i - 1]) continue;
    
    var left = i + 1;
    var right = nums.length - 1;
    
    while (left < right) {
      final sum = nums[i] + nums[left] + nums[right];
      
      if (sum < 0) {
        left++;
      } else if (sum > 0) {
        right--;
      } else {
        result.add([nums[i], nums[left], nums[right]]);
        
        // Skip duplicates
        while (left < right && nums[left] == nums[left + 1]) left++;
        while (left < right && nums[right] == nums[right - 1]) right--;
        
        left++;
        right--;
      }
    }
  }
  
  return result;
}
```

These examples cover a wide range of array problems and techniques. Practice implementing and understanding these solutions to master array manipulation in Dart.