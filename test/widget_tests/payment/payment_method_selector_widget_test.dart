import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Payment Method Selector Widget Tests', () {
    testWidgets('should display all payment methods', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PaymentMethodSelector())),
      );

      // Assert
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Card'), findsOneWidget);
      expect(find.text('UPI'), findsOneWidget);
    });

    testWidgets('should select payment method on tap', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PaymentMethodSelector())),
      );

      // Act
      await tester.tap(find.text('UPI'));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should call onMethodSelected when method is chosen', (
      tester,
    ) async {
      // Arrange
      String? selectedMethod;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodSelector(
              onMethodSelected: (method) => selectedMethod = method,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Card'));
      await tester.pump();

      // Assert
      expect(selectedMethod, 'Card');
    });

    testWidgets('should show confirm button only when method is selected', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: PaymentMethodSelector())),
      );

      // Assert - initially no confirm button
      expect(find.text('Confirm Payment'), findsNothing);

      // Act
      await tester.tap(find.text('Cash'));
      await tester.pump();

      // Assert - confirm button appears
      expect(find.text('Confirm Payment'), findsOneWidget);
    });
  });
}

// Mock widget
class PaymentMethodSelector extends StatefulWidget {
  final Function(String)? onMethodSelected;

  const PaymentMethodSelector({Key? key, this.onMethodSelected})
    : super(key: key);

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  String? _selectedMethod;
  final List<String> _methods = ['Cash', 'Card', 'UPI'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._methods.map(
          (method) => ListTile(
            title: Text(method),
            trailing: _selectedMethod == method
                ? const Icon(Icons.check_circle)
                : null,
            onTap: () {
              setState(() {
                _selectedMethod = method;
              });
              widget.onMethodSelected?.call(method);
            },
          ),
        ),
        if (_selectedMethod != null)
          ElevatedButton(
            onPressed: () {},
            child: const Text('Confirm Payment'),
          ),
      ],
    );
  }
}
