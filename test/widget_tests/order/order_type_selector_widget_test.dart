import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Type Selection Widget Tests', () {
    testWidgets('should display all order type options', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: OrderTypeSelector())),
      );

      // Assert
      expect(find.text('Dine-In'), findsOneWidget);
      expect(find.text('Takeaway'), findsOneWidget);
      expect(find.text('Delivery'), findsOneWidget);
    });

    testWidgets('should highlight selected order type', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: OrderTypeSelector())),
      );

      // Act
      await tester.tap(find.text('Takeaway'));
      await tester.pump();

      // Assert
      final takeawayCard = tester.widget<Card>(
        find.ancestor(of: find.text('Takeaway'), matching: find.byType(Card)),
      );
      expect(takeawayCard.color, Colors.blue[100]);
    });

    testWidgets('should call onOrderTypeSelected when option is tapped', (
      tester,
    ) async {
      // Arrange
      String? selectedType;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderTypeSelector(
              onOrderTypeSelected: (type) => selectedType = type,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Delivery'));
      await tester.pump();

      // Assert
      expect(selectedType, 'Delivery');
    });
  });
}

// Mock widget
class OrderTypeSelector extends StatefulWidget {
  final Function(String)? onOrderTypeSelected;

  const OrderTypeSelector({Key? key, this.onOrderTypeSelected})
    : super(key: key);

  @override
  State<OrderTypeSelector> createState() => _OrderTypeSelectorState();
}

class _OrderTypeSelectorState extends State<OrderTypeSelector> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOrderTypeCard('Dine-In'),
        _buildOrderTypeCard('Takeaway'),
        _buildOrderTypeCard('Delivery'),
      ],
    );
  }

  Widget _buildOrderTypeCard(String type) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
        widget.onOrderTypeSelected?.call(type);
      },
      child: Card(
        color: isSelected ? Colors.blue[100] : null,
        child: Padding(padding: const EdgeInsets.all(16.0), child: Text(type)),
      ),
    );
  }
}
