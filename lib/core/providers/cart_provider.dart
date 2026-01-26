import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String name;
  final String price;
  final String icon;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? price,
    String? icon,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere(
      (cartItem) => cartItem.id == item.id,
    );

    if (existingIndex >= 0) {
      // Item already in cart, increase quantity
      final updatedItem = state[existingIndex].copyWith(
        quantity: state[existingIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // New item, add to cart
      state = [...state, item];
    }
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
    } else {
      final index = state.indexWhere((item) => item.id == itemId);
      if (index >= 0) {
        final updatedItem = state[index].copyWith(quantity: quantity);
        state = [
          ...state.sublist(0, index),
          updatedItem,
          ...state.sublist(index + 1),
        ];
      }
    }
  }

  void clearCart() {
    state = [];
  }

  double getTotalPrice() {
    return state.fold(0.0, (total, item) {
      final price = double.tryParse(item.price.replaceAll('Rs. ', '')) ?? 0.0;
      return total + (price * item.quantity);
    });
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
