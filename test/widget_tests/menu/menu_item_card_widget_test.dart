import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Menu Item Card Widget Tests', () {
    final testItem = MenuItem(
      id: '1',
      name: 'Pizza',
      price: 500.0,
      image: 'pizza.jpg',
    );

    testWidgets('should display item name and price', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MenuItemCard(item: testItem)),
        ),
      );

      // Assert
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('₹500.0'), findsOneWidget);
    });

    testWidgets('should show add to cart button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MenuItemCard(item: testItem)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('should call onAddToCart when button is tapped', (
      tester,
    ) async {
      // Arrange
      bool wasCallbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MenuItemCard(
              item: testItem,
              onAddToCart: (_) => wasCallbackCalled = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pump();

      // Assert
      expect(wasCallbackCalled, true);
    });
  });
}

// Mock classes
class MenuItem {
  final String id;
  final String name;
  final double price;
  final String image;
  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final Function(MenuItem)? onAddToCart;

  const MenuItemCard({Key? key, required this.item, this.onAddToCart})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(item.name),
          Text('₹${item.price}'),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => onAddToCart?.call(item),
          ),
        ],
      ),
    );
  }
}
