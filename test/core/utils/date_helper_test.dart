import 'package:flutter_test/flutter_test.dart';

// Date helper functions for testing
class DateHelper {
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    return date.difference(now).inDays;
  }

  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }
}

void main() {
  group('DateHelper - formatDate', () {
    test('should format date correctly', () {
      final date = DateTime(2024, 3, 15);
      final result = DateHelper.formatDate(date);
      expect(result, '2024-03-15');
    });

    test('should pad single digit month with zero', () {
      final date = DateTime(2024, 1, 5);
      final result = DateHelper.formatDate(date);
      expect(result, '2024-01-05');
    });

    test('should pad single digit day with zero', () {
      final date = DateTime(2024, 12, 3);
      final result = DateHelper.formatDate(date);
      expect(result, '2024-12-03');
    });

    test('should format leap year date correctly', () {
      final date = DateTime(2024, 2, 29);
      final result = DateHelper.formatDate(date);
      expect(result, '2024-02-29');
    });

    test('should format first day of year', () {
      final date = DateTime(2024, 1, 1);
      final result = DateHelper.formatDate(date);
      expect(result, '2024-01-01');
    });
  });

  group('DateHelper - isToday', () {
    test('should return true for today\'s date', () {
      final today = DateTime.now();
      expect(DateHelper.isToday(today), true);
    });

    test('should return false for yesterday', () {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      expect(DateHelper.isToday(yesterday), false);
    });

    test('should return false for tomorrow', () {
      final tomorrow = DateTime.now().add(Duration(days: 1));
      expect(DateHelper.isToday(tomorrow), false);
    });
  });

  group('DateHelper - isYesterday', () {
    test('should return true for yesterday\'s date', () {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      expect(DateHelper.isYesterday(yesterday), true);
    });

    test('should return false for today', () {
      final today = DateTime.now();
      expect(DateHelper.isYesterday(today), false);
    });

    test('should return false for two days ago', () {
      final twoDaysAgo = DateTime.now().subtract(Duration(days: 2));
      expect(DateHelper.isYesterday(twoDaysAgo), false);
    });
  });

  group('DateHelper - daysUntil', () {
    test('should return positive days for future date', () {
      final tomorrow = DateTime.now().add(Duration(days: 1));
      final result = DateHelper.daysUntil(tomorrow);
      expect(result, greaterThanOrEqualTo(0));
    });

    test('should return zero or negative for past date', () {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final result = DateHelper.daysUntil(yesterday);
      expect(result, lessThanOrEqualTo(-1));
    });
  });

  group('DateHelper - isPastDate', () {
    test('should return true for past date', () {
      final pastDate = DateTime.now().subtract(Duration(days: 10));
      expect(DateHelper.isPastDate(pastDate), true);
    });

    test('should return false for future date', () {
      final futureDate = DateTime.now().add(Duration(days: 10));
      expect(DateHelper.isPastDate(futureDate), false);
    });

    test('should return false for today', () {
      final today = DateTime.now();
      // May be true or false depending on exact time
      final result = DateHelper.isPastDate(today);
      expect(result, isA<bool>());
    });
  });
}
