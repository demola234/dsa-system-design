String removeDuplicatesCharacters<T extends Comparable>(List<String> chars) {
  final map = <String, int>{};
  final n = chars.length;
  var result = '';
  for (var i = 0; i < n; i++) {
    if (map.containsKey(chars[i])) {
      map[chars[i]] = map[chars[i]]! + 1;
    } else {
      map[chars[i]] = 1;
    }

    if (map[chars[i]]!.compareTo(1) == 0) {
      result += chars[i];
    }
  }

  return result;
}

main() {
  print(removeDuplicatesCharacters(['a', 'b', 'c', 'a', 'b', 'c', 'd']));
}
