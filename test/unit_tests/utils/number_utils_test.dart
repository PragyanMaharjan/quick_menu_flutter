import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Number Utilities Unit Tests', () {
    test('should format number as currency', () {
      expect(1234.56.toCurrency(), 'Rs. 1,234.56');
    });

    test('should check if number is even', () {
      expect(4.isEven, true);
      expect(5.isEven, false);
    });

    test('should check if number is odd', () {
      expect(5.isOdd, true);
      expect(4.isOdd, false);
    });

    test('should calculate percentage', () {
      expect(50.percentageOf(200), 25.0);
    });

    test('should round to specific decimal places', () {
      expect(3.14159.roundToDecimal(2), 3.14);
    });

    test('should check if number is in range', () {
      expect(5.isBetween(1, 10), true);
      expect(15.isBetween(1, 10), false);
    });

    test('should calculate tax amount', () {
      expect(100.0.calculateTax(13), 13.0);
    });

    test('should calculate discount', () {
      expect(100.0.calculateDiscount(20), 20.0);
    });

    test('should format as compact', () {
      expect(1500.toCompact(), '1.5K');
      expect(1500000.toCompact(), '1.5M');
    });

    test('should check if number is positive', () {
      expect(5.isPositive, true);
      expect((-5).isPositive, false);
    });
  });
}

extension NumberExtensions on num {
  String toCurrency() {
    return 'Rs. ${toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  double percentageOf(num total) {
    if (total == 0) return 0;
    return (this / total) * 100;
  }

  double roundToDecimal(int places) {
    final mod = math.pow(10.0, places).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }

  bool get isPositive => this > 0;

  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  double calculateTax(double taxRate) {
    return this * (taxRate / 100);
  }

  double calculateDiscount(double discountRate) {
    return this * (discountRate / 100);
  }

  String toCompact() {
    if (this >= 1000000) {
      return '${(this / 1000000).roundToDecimal(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).roundToDecimal(1)}K';
    }
    return toString();
  }
}
