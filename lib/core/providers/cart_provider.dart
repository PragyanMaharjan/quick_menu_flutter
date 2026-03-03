import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class CartItem {
  final String id;
  final String name;
  final String price;
  final String icon;
  final int quantity;
  final bool isSynced; // Track sync status

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    this.quantity = 1,
    this.isSynced = false,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? price,
    String? icon,
    int? quantity,
    bool? isSynced,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'icon': icon,
      'quantity': quantity,
    };
  }

  // Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      icon: json['icon'],
      quantity: json['quantity'],
      isSynced: true, // API data is already synced
    );
  }
}

class CartNotifier extends Notifier<List<CartItem>> {
  Box<List<dynamic>>? _cartBox;

  @override
  List<CartItem> build() {
    // Initialize Hive box and network info
    _initializeServices();
    _loadCartFromHive();
    _syncUnsyncedItems();
    return [];
  }

  void _initializeServices() {
    // Check if box is open before trying to access it
    if (Hive.isBoxOpen('cart_items')) {
      _cartBox = Hive.box<List<dynamic>>('cart_items');
    }
  }

  void _loadCartFromHive() {
    if (_cartBox != null) {
      final savedItems = _cartBox!.get('items', defaultValue: []);
      if (savedItems != null) {
        state = savedItems.map((item) => item as CartItem).toList();
      }
    }
  }

  Future<void> _syncUnsyncedItems() async {
    // Check if online
    // if (await _networkInfo.isConnected) {
    //   final unsyncedItems = state.where((item) => !item.isSynced).toList();
    //   for (final item in unsyncedItems) {
    //     await _syncItemToApi(item);
    //   }
    // }
  }

  void _saveToHive() {
    if (_cartBox != null) {
      _cartBox!.put('items', state);
    }
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

    // Save to Hive
    _saveToHive();

    // Try to sync if online
    _syncUnsyncedItems();
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();

    // Save to Hive
    _saveToHive();
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

        // Save to Hive
        _saveToHive();

        // Try to sync if online
        _syncUnsyncedItems();
      }
    }
  }

  void clearCart() {
    state = [];

    // Save to Hive
    _saveToHive();
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
