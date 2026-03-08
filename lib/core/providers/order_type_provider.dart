import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Order type enum
enum OrderType {
  dineIn,
  takeaway,
  delivery,
}

extension OrderTypeExtension on OrderType {
  String get displayName {
    switch (this) {
      case OrderType.dineIn:
        return 'Dine-In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  String get icon {
    switch (this) {
      case OrderType.dineIn:
        return '🍽️';
      case OrderType.takeaway:
        return '🛍️';
      case OrderType.delivery:
        return '🚚';
    }
  }
}

/// Provider to manage the order type selected by customer
/// This stores whether the order is dine-in, takeaway, or delivery
final orderTypeProvider = StateProvider<OrderType?>((ref) {
  return null; // Initially null until customer selects
});
