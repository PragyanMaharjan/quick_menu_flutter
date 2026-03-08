import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cart Item Widget Tests', () {
    final testItem = CartItem(
      id: '1',
      name: 'Pizza',
      price: 500.0,
      quantity: 2,
    );

    testWidgets('should display item details correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CartItemWidget(item: testItem)),
        ),
      );

      // Assert
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('₹500.0'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should show increment and decrement buttons', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CartItemWidget(item: testItem)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('should call onQuantityChanged when increment is tapped', (
      tester,
    ) async {
      // Arrange
      int? newQuantity;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartItemWidget(
              item: testItem,
              onQuantityChanged: (qty) => newQuantity = qty,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      expect(newQuantity, 3);
    });

    testWidgets('should call onRemove when remove button is tapped', (
      tester,
    ) async {
      // Arrange
      bool wasRemoveCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartItemWidget(
              item: testItem,
              onRemove: () => wasRemoveCalled = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Assert
      expect(wasRemoveCalled, true);
    });
  });
}

// Mock classes
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int)? onQuantityChanged;
  final VoidCallback? onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    this.onQuantityChanged,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('₹${item.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => onQuantityChanged?.call(item.quantity - 1),
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onQuantityChanged?.call(item.quantity + 1),
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: onRemove),
        ],
      ),
    );
  }
}
