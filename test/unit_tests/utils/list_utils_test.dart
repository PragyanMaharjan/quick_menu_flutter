import 'package:flutter_test/flutter_test.dart';

void main() {
  group('List Utilities Unit Tests', () {
    test('should check if list is empty or null', () {
      List<int>? nullList;
      expect(nullList.isNullOrEmpty(), true);
      expect(<int>[].isNullOrEmpty(), true);
      expect([1, 2, 3].isNullOrEmpty(), false);
    });

    test('should get first element or null', () {
      expect([1, 2, 3].firstOrNull(), 1);
      expect(<int>[].firstOrNull(), null);
    });

    test('should get last element or null', () {
      expect([1, 2, 3].lastOrNull(), 3);
      expect(<int>[].lastOrNull(), null);
    });

    test('should chunk list into smaller lists', () {
      final result = [1, 2, 3, 4, 5].chunk(2);
      expect(result, [
        [1, 2],
        [3, 4],
        [5],
      ]);
    });

    test('should remove duplicates from list', () {
      expect([1, 2, 2, 3, 3, 3].unique(), [1, 2, 3]);
    });

    test('should sum all numbers in list', () {
      expect([1, 2, 3, 4, 5].sum(), 15);
      expect(<int>[].sum(), 0);
    });

    test('should get average of numbers', () {
      expect([1, 2, 3, 4, 5].average(), 3.0);
      expect(<int>[].average(), 0.0);
    });

    test('should get max value from list', () {
      expect([1, 5, 3, 2, 4].maxValue(), 5);
      expect(<int>[].maxValue(), null);
    });

    test('should get min value from list', () {
      expect([1, 5, 3, 2, 4].minValue(), 1);
      expect(<int>[].minValue(), null);
    });

    test('should shuffle list randomly', () {
      final list = [1, 2, 3, 4, 5];
      final shuffled = list.shuffled();
      expect(shuffled.length, list.length);
      expect(shuffled.toSet(), list.toSet());
    });
  });
}

extension ListExtensions<T> on List<T>? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }
}

extension ListOperations<T> on List<T> {
  T? firstOrNull() {
    return this.isEmpty ? null : first;
  }

  T? lastOrNull() {
    return this.isEmpty ? null : last;
  }

  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  List<T> unique() {
    return toSet().toList();
  }

  List<T> shuffled() {
    final newList = List<T>.from(this);
    newList.shuffle();
    return newList;
  }
}

extension NumListExtensions on List<num> {
  num sum() {
    if (this.isEmpty) return 0;
    return fold<num>(0, (total, value) => total + value);
  }

  double average() {
    if (this.isEmpty) return 0.0;
    return sum() / length;
  }

  num? maxValue() {
    if (this.isEmpty) return null;
    num max = this[0];
    for (final value in this.skip(1)) {
      if (value > max) max = value;
    }
    return max;
  }

  num? minValue() {
    if (this.isEmpty) return null;
    num min = this[0];
    for (final value in this.skip(1)) {
      if (value < min) min = value;
    }
    return min;
  }
}
