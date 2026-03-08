import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Map Utilities Unit Tests', () {
    test('should check if map is null or empty', () {
      Map<String, dynamic>? nullMap;
      expect(nullMap.isNullOrEmpty(), true);
      expect(<String, dynamic>{}.isNullOrEmpty(), true);
      expect({'key': 'value'}.isNullOrEmpty(), false);
    });

    test('should get value with default', () {
      final Map<String, dynamic> map = {'name': 'John'};
      expect(map.getOrDefault('name', 'Unknown'), 'John');
      expect(map.getOrDefault('age', 0), 0);
    });

    test('should merge two maps', () {
      final map1 = {'a': 1, 'b': 2};
      final map2 = {'c': 3, 'd': 4};
      expect(map1.merge(map2), {'a': 1, 'b': 2, 'c': 3, 'd': 4});
    });

    test('should filter map by predicate', () {
      final map = {'a': 1, 'b': 2, 'c': 3, 'd': 4};
      final result = map.filterValues((v) => v > 2);
      expect(result, {'c': 3, 'd': 4});
    });

    test('should check if map contains key', () {
      final map = {'name': 'John', 'age': 30};
      expect(map.hasKey('name'), true);
      expect(map.hasKey('email'), false);
    });

    test('should get all keys as list', () {
      final map = {'a': 1, 'b': 2, 'c': 3};
      expect(map.keysList(), ['a', 'b', 'c']);
    });

    test('should get all values as list', () {
      final map = {'a': 1, 'b': 2, 'c': 3};
      expect(map.valuesList(), [1, 2, 3]);
    });

    test('should invert map keys and values', () {
      final map = {'a': 1, 'b': 2};
      expect(map.invert(), {1: 'a', 2: 'b'});
    });

    test('should remove null values', () {
      final map = {'a': 1, 'b': null, 'c': 3};
      expect(map.removeNulls(), {'a': 1, 'c': 3});
    });

    test('should transform map values', () {
      final map = {'a': 1, 'b': 2, 'c': 3};
      final result = map.mapValues((v) => v * 2);
      expect(result, {'a': 2, 'b': 4, 'c': 6});
    });
  });
}

extension MapExtensions<K, V> on Map<K, V>? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }
}

extension MapOperations<K, V> on Map<K, V> {
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key] as V : defaultValue;
  }

  Map<K, V> merge(Map<K, V> other) {
    return {...this, ...other};
  }

  Map<K, V> filterValues(bool Function(V) predicate) {
    return Map.fromEntries(entries.where((entry) => predicate(entry.value)));
  }

  bool hasKey(K key) {
    return containsKey(key);
  }

  List<K> keysList() {
    return keys.toList();
  }

  List<V> valuesList() {
    return values.toList();
  }

  Map<V, K> invert() {
    return Map.fromEntries(
      entries.map((entry) => MapEntry(entry.value, entry.key)),
    );
  }

  Map<K, V> removeNulls() {
    return Map.fromEntries(entries.where((entry) => entry.value != null));
  }

  Map<K, R> mapValues<R>(R Function(V) transform) {
    return map((key, value) => MapEntry(key, transform(value)));
  }
}
