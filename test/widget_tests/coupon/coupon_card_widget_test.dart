import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Coupon Card Widget Tests', () {
    final testCoupon = Coupon(
      code: 'SAVE10',
      discount: 10,
      type: 'percentage',
      description: 'Get 10% off',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    );

    testWidgets('should display coupon details', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CouponCard(coupon: testCoupon)),
        ),
      );

      // Assert
      expect(find.text('SAVE10'), findsOneWidget);
      expect(find.text('Get 10% off'), findsOneWidget);
      expect(find.textContaining('10%'), findsOneWidget);
    });

    testWidgets('should show apply button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CouponCard(coupon: testCoupon)),
        ),
      );

      // Assert
      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('should call onApply when apply button is tapped', (
      tester,
    ) async {
      // Arrange
      Coupon? appliedCoupon;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CouponCard(
              coupon: testCoupon,
              onApply: (coupon) => appliedCoupon = coupon,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Apply'));
      await tester.pump();

      // Assert
      expect(appliedCoupon, testCoupon);
    });

    testWidgets('should display expiry date', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CouponCard(coupon: testCoupon)),
        ),
      );

      // Assert
      expect(find.textContaining('Expires'), findsOneWidget);
    });
  });
}

// Mock classes
class Coupon {
  final String code;
  final double discount;
  final String type;
  final String description;
  final DateTime expiryDate;

  Coupon({
    required this.code,
    required this.discount,
    required this.type,
    required this.description,
    required this.expiryDate,
  });
}

class CouponCard extends StatelessWidget {
  final Coupon coupon;
  final Function(Coupon)? onApply;

  const CouponCard({Key? key, required this.coupon, this.onApply})
    : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coupon.code,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${coupon.discount}${coupon.type == 'percentage' ? '%' : '₹'} OFF',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(coupon.description),
            const SizedBox(height: 8),
            Text(
              'Expires: ${_formatDate(coupon.expiryDate)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => onApply?.call(coupon),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
