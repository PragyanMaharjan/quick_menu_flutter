import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// 🥡 Starter Screen - Appetizing Beginning to Your Meal
class StarterScreen extends ConsumerStatefulWidget {
  const StarterScreen({super.key});

  @override
  ConsumerState<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends ConsumerState<StarterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  static const List<StarterItem> starterItems = [
    StarterItem(
      name: "Crispy Spring Rolls",
      description: "Golden, crunchy rolls with veggies & spices",
      price: "Rs. 180",
      icon: "🍱",
      imagePath: "assets/image/spring_rolls.jpeg",
      isVegetarian: true,
      cookTime: "8 mins",
      rating: 4.8,
    ),
    StarterItem(
      name: "Paneer Tikka",
      description: "Marinated cottage cheese grilled to perfection",
      price: "Rs. 220",
      icon: "🔥",
      imagePath: "assets/image/paneer_tikka.jpeg",
      isVegetarian: true,
      cookTime: "12 mins",
      rating: 4.9,
    ),
    StarterItem(
      name: "Chicken Wings",
      description: "Spicy & juicy wings with special sauce",
      price: "Rs. 250",
      icon: "🍗",
      imagePath: "assets/image/chicken_wings.jpeg",
      isVegetarian: false,
      cookTime: "15 mins",
      rating: 4.7,
    ),
    StarterItem(
      name: "Mozzarella Sticks",
      description: "Stretchy, cheesy goodness in every bite",
      price: "Rs. 200",
      icon: "🧀",
      imagePath: "assets/image/mozzarella.jpeg",
      isVegetarian: true,
      cookTime: "6 mins",
      rating: 4.6,
    ),
    StarterItem(
      name: "Seekh Kebab",
      description: "Minced meat kebab with aromatic spices",
      price: "Rs. 280",
      icon: "🌶️",
      imagePath: "assets/image/seekh_kebab.jpeg",
      isVegetarian: false,
      cookTime: "14 mins",
      rating: 4.8,
    ),
  ];

  void _addToCart(StarterItem item) {
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
    SnackBarUtils.success(context, "✓ ${item.name} added to cart!");
  }

  void _showStarterDetails(BuildContext context, StarterItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
            // ✨ Decorative top bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // 🖼️ Image with decorative frame
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📝 Item details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.icon} ${item.name}",
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
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
                    color: const Color(0xFFF7971E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.price,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF7971E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ⏱️ Cook time & Rating
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.timer_outlined, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  item.cookTime,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star, color: Colors.amber),
                ),
                const SizedBox(width: 8),
                Text(
                  "${item.rating}",
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🛒 Add to cart button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05757),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _addToCart(item);
              },
              child: const Text(
                "🛒 ADD TO CART",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
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
            backgroundColor: const Color(0xFFE05757),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE05757),
                      const Color(0xFFF7971E).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "🥡 Starters",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Perfect appetizers to kick-start your meal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // 🍽️ Starters list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = starterItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _StarterCard(
                    item: item,
                    onTap: () => _showStarterDetails(context, item),
                    isSelected: false,
                  ),
                );
              }, childCount: starterItems.length),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎴 Custom starter card widget
class _StarterCard extends StatefulWidget {
  final StarterItem item;
  final VoidCallback onTap;
  final bool isSelected;

  const _StarterCard({
    required this.item,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<_StarterCard> createState() => _StarterCardState();
}

class _StarterCardState extends State<_StarterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFE05757)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // 🖼️ Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade100,
                    child: Image.asset(
                      widget.item.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // 📝 Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.item.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.item.name,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (widget.item.isVegetarian)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "🌱 Veg",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          const Spacer(),
                          Text(
                            widget.item.price,
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF7971E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ✅ Selection indicator
                if (widget.isSelected)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE05757),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StarterItem {
  final String name;
  final String description;
  final String price;
  final String icon;
  final String imagePath;
  final bool isVegetarian;
  final String cookTime;
  final double rating;

  const StarterItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imagePath,
    required this.isVegetarian,
    required this.cookTime,
    required this.rating,
  });
}
