import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// 🎁 Combo Screen - Unbeatable Deals & Bundles
class ComboScreen extends ConsumerStatefulWidget {
  const ComboScreen({super.key});

  @override
  ConsumerState<ComboScreen> createState() => _ComboScreenState();
}

class _ComboScreenState extends ConsumerState<ComboScreen> {
  static const List<ComboItem> combos = [
    ComboItem(
      name: "Romantic Dinner Bundle",
      icon: "💑",
      price: "Rs. 899",
      originalPrice: "Rs. 1200",
      discount: "25%",
      imagePath: "assets/image/romantic_combo.jpeg",
      items: ["Butter Chicken", "Garlic Naan", "Red Wine", "Dessert"],
      servings: 2,
      color: Colors.red,
    ),
    ComboItem(
      name: "Family Feast Combo",
      icon: "👨‍👩‍👧‍👦",
      price: "Rs. 1499",
      originalPrice: "Rs. 2100",
      discount: "28%",
      imagePath: "assets/image/family_feast.jpeg",
      items: [
        "Tandoori Chicken",
        "Paneer Tikka",
        "Biryani",
        "Drinks",
        "Dessert",
      ],
      servings: 4,
      color: Colors.green,
    ),
    ComboItem(
      name: "Office Lunch Bundle",
      icon: "💼",
      price: "Rs. 599",
      originalPrice: "Rs. 850",
      discount: "29%",
      imagePath: "assets/image/office_lunch.jpeg",
      items: ["Sandwich", "Salad", "Juice", "Chips"],
      servings: 1,
      color: Colors.blue,
    ),
    ComboItem(
      name: "Party Platter Supreme",
      icon: "🎉",
      price: "Rs. 2499",
      originalPrice: "Rs. 3500",
      discount: "28%",
      imagePath: "assets/image/party_platter.jpeg",
      items: [
        "Assorted Starters",
        "Mains",
        "Sides",
        "Drinks",
        "Dessert Platter",
      ],
      servings: 6,
      color: Colors.purple,
    ),
    ComboItem(
      name: "Vegan Delight Pack",
      icon: "🥗",
      price: "Rs. 449",
      originalPrice: "Rs. 650",
      discount: "30%",
      imagePath: "assets/image/vegan_pack.jpeg",
      items: ["Veggie Burger", "Fries", "Smoothie", "Salad"],
      servings: 1,
      color: Colors.green,
    ),
    ComboItem(
      name: "Movie Night Special",
      icon: "🍿",
      price: "Rs. 399",
      originalPrice: "Rs. 600",
      discount: "33%",
      imagePath: "assets/image/movie_special.jpeg",
      items: ["Pizza Slice", "Popcorn", "Nachos", "Soda"],
      servings: 2,
      color: Colors.orange,
    ),
  ];

  void _addToCart(ComboItem item) {
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
    SnackBarUtils.success(context, "🎁 ${item.name} added to cart!");
  }

  void _showComboDetails(BuildContext context, ComboItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✨ Handle
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🎁 Image showcase
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      height: 240,
                      color: Colors.grey.shade100,
                      child: Image.asset(item.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 📝 Combo details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          Text(item.icon, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price breakdown
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: item.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Original Price",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.originalPrice,
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Save ${item.discount}",
                                style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "You Pay",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.price,
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: item.color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Included items
                      const Text(
                        "📦 What's Included:",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: item.items
                            .map(
                              (itemName) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: item.color.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "✓",
                                          style: TextStyle(
                                            color: item.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      itemName,
                                      style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),

                      // Servings info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.people,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Serves ${item.servings} ${item.servings > 1 ? "people" : "person"}",
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Add to cart button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _addToCart(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: item.color,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          "🛒 ADD TO CART - ${item.price}",
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // 🎨 Animated header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.purple,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade700, Colors.pink.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🎁", style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      "Combo Deals",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Amazing bundles, unbeatable prices!",
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

          // 🎁 Combos grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final combo = combos[index];
                return _ComboCard(
                  combo: combo,
                  onTap: () => _showComboDetails(context, combo),
                );
              }, childCount: combos.length),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }
}

class _ComboCard extends StatelessWidget {
  final ComboItem combo;
  final VoidCallback onTap;

  const _ComboCard({required this.combo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: combo.color.withOpacity(0.2),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              // 🖼️ Background image
              Positioned.fill(
                child: Image.asset(combo.imagePath, fit: BoxFit.cover),
              ),

              // 🎨 Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        combo.color.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // 📝 Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top - Badge & discount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                combo.icon,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                combo.name,
                                style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "SAVE ${combo.discount}",
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Bottom - Price & servings
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              combo.originalPrice,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              combo.price,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Serves ${combo.servings}",
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
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

class ComboItem {
  final String name;
  final String icon;
  final String price;
  final String originalPrice;
  final String discount;
  final String imagePath;
  final List<String> items;
  final int servings;
  final Color color;

  const ComboItem({
    required this.name,
    required this.icon,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.imagePath,
    required this.items,
    required this.servings,
    required this.color,
  });
}
