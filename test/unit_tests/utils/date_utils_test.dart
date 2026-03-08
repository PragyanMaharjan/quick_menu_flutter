import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Utilities Unit Tests', () {
    final testDate = DateTime(2024, 3, 15, 14, 30);

    test('should format date as readable string', () {
      expect(testDate.toReadable(), 'March 15, 2024');
    });

    test('should check if date is today', () {
      final today = DateTime.now();
      expect(today.isToday(), true);
      expect(testDate.isToday(), false);
    });

    test('should check if date is yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isYesterday(), true);
    });

    test('should check if date is in the past', () {
      expect(testDate.isPast(), true);
      final future = DateTime.now().add(const Duration(days: 1));
      expect(future.isPast(), false);
    });

    test('should check if date is in the future', () {
      final future = DateTime.now().add(const Duration(days: 1));
      expect(future.isFuture(), true);
      expect(testDate.isFuture(), false);
    });

    test('should get difference in days', () {
      final otherDate = DateTime(2024, 3, 20);
      expect(testDate.differenceInDays(otherDate), 4);
    });

    test('should get time ago string', () {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      expect(oneHourAgo.timeAgo().contains('ago'), true);
    });

    test('should get start of day', () {
      final startOfDay = testDate.startOfDay();
      expect(startOfDay.hour, 0);
      expect(startOfDay.minute, 0);
      expect(startOfDay.second, 0);
    });

    test('should get end of day', () {
      final endOfDay = testDate.endOfDay();
      expect(endOfDay.hour, 23);
      expect(endOfDay.minute, 59);
      expect(endOfDay.second, 59);
    });

    test('should add business days', () {
      final monday = DateTime(2024, 3, 11); // Monday
      final result = monday.addBusinessDays(5);
      expect(result.weekday, DateTime.monday);
    });
  });
}

extension DateExtensions on DateTime {
  String toReadable() {
    final months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month]} $day, $year';
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool isPast() {
    return isBefore(DateTime.now());
  }

  bool isFuture() {
    return isAfter(DateTime.now());
  }

  int differenceInDays(DateTime other) {
    return other.difference(this).inDays;
  }

  String timeAgo() {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }

  DateTime startOfDay() {
    return DateTime(year, month, day, 0, 0, 0);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  DateTime addBusinessDays(int days) {
    var result = this;
    var addedDays = 0;
    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }
    return result;
  }
}
