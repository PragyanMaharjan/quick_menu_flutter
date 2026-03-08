import 'package:flutter_test/flutter_test.dart';

void main() {
  group('String Utilities Unit Tests', () {
    test('should capitalize first letter of string', () {
      final result = 'hello'.capitalize();
      expect(result, 'Hello');
    });

    test('should return empty string when capitalizing empty string', () {
      final result = ''.capitalize();
      expect(result, '');
    });

    test('should check if string is email format', () {
      expect('test@gmail.com'.isValidEmail(), true);
      expect('invalid'.isValidEmail(), false);
    });

    test('should check if string contains only numbers', () {
      expect('12345'.isNumeric(), true);
      expect('123abc'.isNumeric(), false);
    });

    test('should truncate long strings', () {
      final longString = 'This is a very long string that needs truncation';
      expect(longString.truncate(10), 'This is a ...');
    });

    test('should remove all whitespace from string', () {
      expect('hello world'.removeWhitespace(), 'helloworld');
    });

    test('should count words in string', () {
      expect('hello world test'.wordCount(), 3);
      expect(''.wordCount(), 0);
    });

    test('should reverse string', () {
      expect('hello'.reverse(), 'olleh');
      expect(''.reverse(), '');
    });

    test('should check if string is palindrome', () {
      expect('racecar'.isPalindrome(), true);
      expect('hello'.isPalindrome(), false);
    });

    test('should convert string to title case', () {
      expect('hello world'.toTitleCase(), 'Hello World');
    });
  });
}

extension StringExtensions on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool isNumeric() {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }

  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  int wordCount() {
    if (this.isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  String reverse() {
    return split('').reversed.join('');
  }

  bool isPalindrome() {
    final cleaned = toLowerCase().removeWhitespace();
    return cleaned == cleaned.reverse();
  }

  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
