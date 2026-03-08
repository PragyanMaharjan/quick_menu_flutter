import 'package:flutter_test/flutter_test.dart';

// String helper functions for testing
class StringHelper {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncate(String text, int length) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  static bool isNumeric(String text) {
    if (text.isEmpty) return false;
    return double.tryParse(text) != null;
  }

  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }
}

void main() {
  group('StringHelper - capitalize', () {
    test('should capitalize first letter of string', () {
      final result = StringHelper.capitalize('hello');
      expect(result, 'Hello');
    });

    test('should return same string if already capitalized', () {
      final result = StringHelper.capitalize('Hello');
      expect(result, 'Hello');
    });

    test('should handle empty string', () {
      final result = StringHelper.capitalize('');
      expect(result, '');
    });

    test('should capitalize single character', () {
      final result = StringHelper.capitalize('a');
      expect(result, 'A');
    });

    test('should capitalize with numbers', () {
      final result = StringHelper.capitalize('123abc');
      expect(result, '123abc');
    });
  });

  group('StringHelper - truncate', () {
    test('should truncate string longer than specified length', () {
      final result = StringHelper.truncate('Hello World', 5);
      expect(result, 'Hello...');
    });

    test('should not truncate string shorter than specified length', () {
      final result = StringHelper.truncate('Hi', 5);
      expect(result, 'Hi');
    });

    test('should handle exact length match', () {
      final result = StringHelper.truncate('Hello', 5);
      expect(result, 'Hello');
    });

    test('should handle empty string', () {
      final result = StringHelper.truncate('', 5);
      expect(result, '');
    });

    test('should handle length zero', () {
      final result = StringHelper.truncate('Hello', 0);
      expect(result, '...');
    });
  });

  group('StringHelper - isNumeric', () {
    test('should return true for numeric string', () {
      expect(StringHelper.isNumeric('123'), true);
    });

    test('should return true for decimal number', () {
      expect(StringHelper.isNumeric('123.45'), true);
    });

    test('should return true for negative number', () {
      expect(StringHelper.isNumeric('-123'), true);
    });

    test('should return false for non-numeric string', () {
      expect(StringHelper.isNumeric('abc'), false);
    });

    test('should return false for empty string', () {
      expect(StringHelper.isNumeric(''), false);
    });

    test('should return false for mixed alphanumeric', () {
      expect(StringHelper.isNumeric('123abc'), false);
    });
  });

  group('StringHelper - removeWhitespace', () {
    test('should remove all whitespace characters', () {
      final result = StringHelper.removeWhitespace('Hello World');
      expect(result, 'HelloWorld');
    });

    test('should handle multiple spaces', () {
      final result = StringHelper.removeWhitespace('Hello     World');
      expect(result, 'HelloWorld');
    });

    test('should remove tabs and newlines', () {
      final result = StringHelper.removeWhitespace('Hello\tWorld\nTest');
      expect(result, 'HelloWorldTest');
    });

    test('should return same string if no whitespace', () {
      final result = StringHelper.removeWhitespace('HelloWorld');
      expect(result, 'HelloWorld');
    });

    test('should handle empty string', () {
      final result = StringHelper.removeWhitespace('');
      expect(result, '');
    });
  });
}
