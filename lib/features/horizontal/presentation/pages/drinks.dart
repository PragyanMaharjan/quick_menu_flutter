import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// 🥤 Drinks Screen - Refreshing Beverages
class DrinksScreen extends ConsumerStatefulWidget {
  const DrinksScreen({super.key});

  @override
  ConsumerState<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends ConsumerState<DrinksScreen> {
  String selectedCategory = "All";

  static const List<DrinkItem> allDrinks = [
    DrinkItem(
      name: "Fresh Mango Juice",
      category: "Juices",
      price: "Rs. 120",
      icon: "🥭",
      imagePath: "assets/image/mango_juice.jpeg",
      temperature: "Cold",
      size: "500ml",
      healthScore: 9,
    ),
    DrinkItem(
      name: "Iced Coffee",
      category: "Coffee",
      price: "Rs. 180",
      icon: "☕",
      imagePath: "assets/image/iced_coffee.jpeg",
      temperature: "Cold",
      size: "350ml",
      healthScore: 6,
    ),
    DrinkItem(
      name: "Strawberry Smoothie",
      category: "Smoothies",
      price: "Rs. 200",
      icon: "🍓",
      imagePath: "assets/image/strawberry_smoothie.jpeg",
      temperature: "Cold",
      size: "400ml",
      healthScore: 8,
    ),
    DrinkItem(
      name: "Masala Chai",
      category: "Tea",
      price: "Rs. 80",
      icon: "🫖",
      imagePath: "assets/image/masala_chai.jpeg",
      temperature: "Hot",
      size: "250ml",
      healthScore: 7,
    ),
    DrinkItem(
      name: "Cola",
      category: "Soft Drinks",
      price: "Rs. 100",
      icon: "🥤",
      imagePath: "assets/image/cola.jpeg",
      temperature: "Cold",
      size: "330ml",
      healthScore: 3,
    ),
    DrinkItem(
      name: "Lassi",
      category: "Smoothies",
      price: "Rs. 140",
      icon: "🍨",
      imagePath: "assets/image/lassi.jpeg",
      temperature: "Cold",
      size: "300ml",
      healthScore: 8,
    ),
  ];

  final List<String> categories = [
    "All",
    "Juices",
    "Coffee",
    "Tea",
    "Smoothies",
    "Soft Drinks",
  ];

  List<DrinkItem> getFilteredDrinks() {
    if (selectedCategory == "All") {
      return allDrinks;
    }
    return allDrinks
        .where((drink) => drink.category == selectedCategory)
        .toList();
  }

  void _addToCart(DrinkItem item) {
    ref
        .read(cartProvider.notifier)
        .addItem(
          CartItem(
            id: item.name,
            name: item.name,
            price: item.price,
            icon: item.icon,
          ),
        );
    SnackBarUtils.success(context, "🥤 ${item.name} added!");
  }

  void _showDrinkDetails(BuildContext context, DrinkItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✨ Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // 🎯 Drink emoji - large
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(item.icon, style: const TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 16),

            // 📝 Drink name
            Text(
              item.name,
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            // 🏷️ Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF56ab2f).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.category,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF56ab2f),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🖼️ Drink image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade100,
                child: Image.asset(item.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),

            // 📊 Drink specs - horizontal layout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SpecCard(
                    icon: "🌡️",
                    label: "Temperature",
                    value: item.temperature,
                  ),
                  Container(width: 1, height: 50, color: Colors.grey.shade300),
                  _SpecCard(icon: "📏", label: "Size", value: item.size),
                  Container(width: 1, height: 50, color: Colors.grey.shade300),
                  _SpecCard(
                    icon: "💚",
                    label: "Health",
                    value: "${item.healthScore}/10",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 💰 Price and action buttons
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.price,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _addToCart(item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "🛒 Add",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDrinks = getFilteredDrinks();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // 🎨 Animated header
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.cyan.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🥤", style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      "Refreshing Drinks",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Stay hydrated & enjoy our premium beverages",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),

          // 🏷️ Category filter chips
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FilterChip(
                            label: Text(
                              category,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                color: selectedCategory == category
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                            backgroundColor: selectedCategory == category
                                ? Colors.blue
                                : Colors.white,
                            side: BorderSide(
                              color: selectedCategory == category
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            onSelected: (selected) {
                              setState(() => selectedCategory = category);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // 🥤 Drinks grid
          if (filteredDrinks.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🤷", style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      "No drinks in this category",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Try selecting a different category",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final drink = filteredDrinks[index];
                  return _DrinkCard(
                    drink: drink,
                    onTap: () => _showDrinkDetails(context, drink),
                  );
                }, childCount: filteredDrinks.length),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}

class _DrinkCard extends StatelessWidget {
  final DrinkItem drink;
  final VoidCallback onTap;

  const _DrinkCard({required this.drink, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  height: 130,
                  color: Colors.grey.shade100,
                  child: Image.asset(drink.imagePath, fit: BoxFit.cover),
                ),
              ),

              // 📝 Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(drink.icon, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            drink.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            drink.size,
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Text(
                          drink.price,
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                      ],
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

class _SpecCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _SpecCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class DrinkItem {
  final String name;
  final String category;
  final String price;
  final String icon;
  final String imagePath;
  final String temperature;
  final String size;
  final int healthScore;

  const DrinkItem({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.imagePath,
    required this.temperature,
    required this.size,
    required this.healthScore,
  });
}
