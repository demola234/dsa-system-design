import 'dart:async';
import 'dart:io';

toCamelCase(String s) {
  var result = '';
  var words = s.split(RegExp(r'[-_]'));
  for (var i = 0; i < words.length; i++) {
    if (i == 0) {
      result += words[i];
    } else {
      result += words[i][0].toUpperCase() + words[i].substring(1);
    }
  }
  return result;
}

rearrange(List<String> args) {
  String result = "";
  Map<String, String> characterMap;
  if (args.length < 0 && args == null) {
    return result;
  } else {
    // if element in a string are repeated the repeated character should come first before the other ones , if the more than on e repeated character the highest  number of characters should always come first
  }
}

String brainLuck(String code, String input) {
  final memory =
      List<int>.filled(30000, 0); // Memory tape with a few thousand cells
  int pointer = 0; // Memory pointer
  int inputPointer = 0; // Input pointer for reading input string
  final output = StringBuffer(); // Output buffer

  for (int i = 0; i < code.length; i++) {
    switch (code[i]) {
      case '>':
        pointer++;
        break;
      case '<':
        pointer--;
        break;
      case '+':
        memory[pointer] = (memory[pointer] + 1) % 256;
        break;
      case '-':
        memory[pointer] = (memory[pointer] - 1) % 256;
        break;
      case '.':
        output.write(String.fromCharCode(memory[pointer]));
        break;
      case ',':
        if (inputPointer < input.length) {
          memory[pointer] = input.codeUnitAt(inputPointer++);
        }
        break;
      case '[':
        if (memory[pointer] == 0) {
          // Jump forward to the matching ']'
          int loopCount = 1;
          while (loopCount > 0) {
            i++;
            if (code[i] == '[') {
              loopCount++;
            } else if (code[i] == ']') {
              loopCount--;
            }
          }
        }
        break;
      case ']':
        if (memory[pointer] != 0) {
          // Jump back to the matching '['
          int loopCount = 1;
          while (loopCount > 0) {
            i--;
            if (code[i] == ']') {
              loopCount++;
            } else if (code[i] == '[') {
              loopCount--;
            }
          }
        }
        break;
    }
  }

  return output.toString();
}

int gcd(int a, int b) {
  return b == 0 ? a : gcd(b, a % b);
}

int lcm(int a, int b) {
  return (a * b).abs() ~/ gcd(a, b);
}

String convertFrac(List<List<int>> lst) {
  List<int> denominators = lst.map((frac) => frac[1]).toList();
  int lcmDenominator = denominators.reduce(lcm);

  List<String> result = lst.map((frac) {
    int numerator = frac[0] * (lcmDenominator ~/ frac[1]);
    return '($numerator,$lcmDenominator)';
  }).toList();

  return result.join('');
}

// Dummy function to compress a single file
Future<File> compressFile(File file) async {
  // Simulate compression delay
  await Future.delayed(Duration(seconds: 1));
  return file; // Return the file as is for this dummy function
}

// Dummy function to upload a single file
Future<File> uploadFile(File file) async {
  // Simulate upload delay
  await Future.delayed(Duration(seconds: 1));
  return file; // Return the file as is for this dummy function
}

Future<List<File>> compressAndUploadFiles(List<File> files) async {
  final int maxConcurrentTasks = 5;
  List<Future<File>> compressedAndUploadedFutures = [];
  final Semaphore semaphore = Semaphore(maxConcurrentTasks);

  try {
    for (File file in files) {
      compressedAndUploadedFutures.add(semaphore.withPermit(() async {
        return await compressAndUpload(file);
      }));
    }

    // Wait for all the compress and upload operations to complete
    List<File> compressedAndUploadedFiles =
        await Future.wait(compressedAndUploadedFutures);

    return compressedAndUploadedFiles;
  } catch (e) {
    // Handle potential errors during compression or upload
    print('Error: $e');
    return [];
  }
}

Future<File> compressAndUpload(File file) async {
  try {
    File compressedFile = await compressFile(file);
    File uploadedFile = await uploadFile(compressedFile);
    return uploadedFile;
  } catch (e) {
    // Handle potential errors during compression or upload
    print('Error compressing or uploading file: $e');
    rethrow;
  }
}

void main() async {
  List<File> files = [
    File('path/to/file1.jpg'),
    File('path/to/file2.jpg'),
    File('path/to/file3.jpg'),
    File('path/to/file4.jpg'),
    File('path/to/file5.jpg'),
    File('path/to/file6.jpg'),
    File('path/to/file7.jpg'),
    File('path/to/file8.jpg'),
    File('path/to/file9.jpg'),
    File('path/to/file10.jpg'),
    File('path/to/file11.jpg'),
    File('path/to/file12.jpg'),
    File('path/to/file13.jpg'),
    File('path/to/file14.jpg'),
    File('path/to/file15.jpg'),
    File('path/to/file16.jpg'),
    File('path/to/file17.jpg'),
    File('path/to/file18.jpg'),
    File('path/to/file19.jpg'),
    File('path/to/file20.jpg'),
  ];

  final stopwatch = Stopwatch()..start();
  List<File> result = await compressAndUploadFiles(files);
  stopwatch.stop();

  print('Total time taken: ${stopwatch.elapsed.inSeconds} seconds');
  print('Total files processed: ${result.length}');
}

class Semaphore {
  final int maxConcurrent;
  int _current = 0;
  final List<Completer<void>> _queue = [];

  Semaphore(this.maxConcurrent);

  Future<void> acquire() async {
    if (_current < maxConcurrent) {
      _current++;
      return;
    }

    final completer = Completer<void>();
    _queue.add(completer);
    await completer.future;
  }

  void release() {
    if (_queue.isNotEmpty) {
      final completer = _queue.removeAt(0);
      completer.complete();
    } else {
      _current--;
    }
  }

  Future<T> withPermit<T>(Future<T> Function() action) async {
    await acquire();
    try {
      return await action();
    } finally {
      release();
    }
  }
}
