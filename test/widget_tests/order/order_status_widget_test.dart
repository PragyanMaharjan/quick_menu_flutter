import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Order Status Widget Tests', () {
    testWidgets('should display pending status correctly', (tester) async {
      // Arrange
      const order = Order(
        id: '1',
        status: OrderStatus.pending,
        total: 1000.0,
        items: 3,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OrderStatusWidget(order: order)),
        ),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
      expect(find.text('₹1000.0'), findsOneWidget);
    });

    testWidgets('should display preparing status with icon', (tester) async {
      // Arrange
      const order = Order(
        id: '2',
        status: OrderStatus.preparing,
        total: 500.0,
        items: 2,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OrderStatusWidget(order: order)),
        ),
      );

      // Assert
      expect(find.text('Preparing'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });

    testWidgets('should display ready status in green', (tester) async {
      // Arrange
      const order = Order(
        id: '3',
        status: OrderStatus.ready,
        total: 750.0,
        items: 4,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OrderStatusWidget(order: order)),
        ),
      );

      // Assert
      expect(find.text('Ready'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should call onTap when status card is tapped', (tester) async {
      // Arrange
      Order? tappedOrder;
      const order = Order(
        id: '4',
        status: OrderStatus.delivered,
        total: 1200.0,
        items: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrderStatusWidget(
              order: order,
              onTap: (o) => tappedOrder = o,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Card));
      await tester.pump();

      // Assert
      expect(tappedOrder, order);
    });

    testWidgets('should display item count', (tester) async {
      // Arrange
      const order = Order(
        id: '5',
        status: OrderStatus.pending,
        total: 300.0,
        items: 2,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OrderStatusWidget(order: order)),
        ),
      );

      // Assert
      expect(find.textContaining('2 items'), findsOneWidget);
    });
  });
}

// Mock classes
enum OrderStatus { pending, preparing, ready, delivered }

class Order {
  final String id;
  final OrderStatus status;
  final double total;
  final int items;

  const Order({
    required this.id,
    required this.status,
    required this.total,
    required this.items,
  });
}

class OrderStatusWidget extends StatelessWidget {
  final Order order;
  final Function(Order)? onTap;

  const OrderStatusWidget({Key? key, required this.order, this.onTap})
    : super(key: key);

  IconData _getStatusIcon() {
    switch (order.status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.check_circle;
      case OrderStatus.delivered:
        return Icons.done_all;
    }
  }

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    return order.status.name[0].toUpperCase() + order.status.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(order),
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(_getStatusIcon(), color: _getStatusColor(), size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                    Text('${order.items} items'),
                    Text(
                      '₹${order.total}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
