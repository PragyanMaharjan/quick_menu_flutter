import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import 'package:quick_menu/core/theme/app_colors.dart';

// Favorites Provider
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteItem>>((ref) {
      return FavoritesNotifier();
    });

class FavoriteItem {
  final String id;
  final String name;
  final String price;
  final String icon;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'icon': icon,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      icon: json['icon'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}

class FavoritesNotifier extends StateNotifier<List<FavoriteItem>> {
  Box<List<dynamic>>? _favoritesBox;

  FavoritesNotifier() : super([]) {
    _initializeBox();
  }

  void _initializeBox() {
    if (Hive.isBoxOpen('favorites')) {
      _favoritesBox = Hive.box<List<dynamic>>('favorites');
      _loadFavorites();
    }
  }

  void _loadFavorites() {
    if (_favoritesBox != null) {
      final savedFavorites = _favoritesBox!.get('items', defaultValue: []);
      if (savedFavorites != null) {
        state = savedFavorites
            .map(
              (item) => FavoriteItem.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      }
    }
  }

  void _saveFavorites() {
    if (_favoritesBox != null) {
      _favoritesBox!.put('items', state.map((item) => item.toJson()).toList());
    }
  }

  void toggleFavorite(String id, String name, String price, String icon) {
    final existingIndex = state.indexWhere((item) => item.id == id);

    if (existingIndex >= 0) {
      // Remove from favorites
      state = List.from(state)..removeAt(existingIndex);
    } else {
      // Add to favorites
      state = [
        ...state,
        FavoriteItem(id: id, name: name, price: price, icon: icon),
      ];
    }
    _saveFavorites();
  }

  bool isFavorite(String id) {
    return state.any((item) => item.id == id);
  }

  void removeFavorite(String id) {
    state = state.where((item) => item.id != id).toList();
    _saveFavorites();
  }

  void clearFavorites() {
    state = [];
    _saveFavorites();
  }
}

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.headerGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '❤️ My Favorites',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                _showClearConfirmation(context, ref);
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Favorites Yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding your favorite items!',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return _FavoriteItemCard(item: item);
              },
            ),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Clear All Favorites?'),
          content: const Text(
            'This will remove all items from your favorites list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                ref.read(favoritesProvider.notifier).clearFavorites();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Clear', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class _FavoriteItemCard extends ConsumerWidget {
  final FavoriteItem item;

  const _FavoriteItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE05757).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(item.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 12),

            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE05757),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            IconButton(
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Color(0xFFE05757),
              ),
              onPressed: () {
                final cartItem = CartItem(
                  id: item.id,
                  name: item.name,
                  price: item.price,
                  icon: item.icon,
                );
                ref.read(cartProvider.notifier).addItem(cartItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} added to cart'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                ref.read(favoritesProvider.notifier).removeFavorite(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Removed from favorites'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Helper method to add to favorites (can be called from menu items)
void addToFavorites(
  WidgetRef ref,
  String id,
  String name,
  String price,
  String icon,
) {
  ref.read(favoritesProvider.notifier).toggleFavorite(id, name, price, icon);
}

bool isFavorite(WidgetRef ref, String id) {
  return ref.read(favoritesProvider.notifier).isFavorite(id);
}
