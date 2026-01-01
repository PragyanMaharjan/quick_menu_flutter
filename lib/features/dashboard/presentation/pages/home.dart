import 'package:flutter/material.dart';
import 'order_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeTab(),
            OrderScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
// MODEL
///////////////////////////////////////////////////////////
class FoodItem {
  final String title, subtitle, shortDesc, fullDesc, price, imagePath;

  const FoodItem({
    required this.title,
    required this.subtitle,
    required this.shortDesc,
    required this.fullDesc,
    required this.price,
    required this.imagePath,
  });
}

///////////////////////////////////////////////////////////
// HOME TAB
///////////////////////////////////////////////////////////
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const List<FoodItem> items = [
    FoodItem(
      title: "Family Combo",
      subtitle: "Perfect for whole family",
      shortDesc: "A delightful meal for family moments.",
      fullDesc:
      "Includes 2 pizzas, 1 large fries, 4 drinks and a dessert. Perfect for sharing.",
      price: "Rs. 899",
      imagePath: "assets/image/family_combo.jpeg",
    ),
    FoodItem(
      title: "Chicken Chilli",
      subtitle: "Spicy & Crispy",
      shortDesc: "Crispy chicken tossed in chilli sauce.",
      fullDesc: "Juicy crispy chicken coated with spicy chilli sauce and capsicum.",
      price: "Rs. 420",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
  ];

  void _showDishDetails(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // - Improved image in popup (rounded + shadow)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    item.imagePath,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // - Title Bold
              Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),

              // - Price SemiBold
              Text(
                "Price: ${item.price}",
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),

              // - Description Italic
              Text(
                item.fullDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // - Cancel + Add To Cart
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.black26),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE05757),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Add cart logic here
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${item.title} added to cart!",
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "ADD TO CART",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // - FULL-WIDTH HEADER
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE05757), Color(0xFFF7971E)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jhasha effortless QR scanner",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Scan, order, and enjoy delicious food in seconds.",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Calories don’t count when you’re happy",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 14),

          // - HORIZONTAL CATEGORY BUTTONS
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E6),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: const [
                  CategoryChip(text: "Starter"),
                  CategoryChip(text: "Main Course"),
                  CategoryChip(text: "Drinks"),
                  CategoryChip(text: "Popular"),
                  CategoryChip(text: "Combo"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // - MENU LIST
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: items
                  .map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: menuCard(
                    item: item,
                    onTap: () => _showDishDetails(context, item),
                    onDescriptionTap: () => _showDishDetails(context, item),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
// CATEGORY CHIP WIDGET
///////////////////////////////////////////////////////////
class CategoryChip extends StatelessWidget {
  final String text;
  const CategoryChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
// MENU CARD (- UPDATED IMAGE LOOKS CLEAN)
///////////////////////////////////////////////////////////
Widget menuCard({
  required FoodItem item,
  required VoidCallback onTap,
  required VoidCallback onDescriptionTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF56ab2f), Color(0xFFA8e063)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),

                // - Tap ONLY description also opens popup
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDescriptionTap,
                  child: Text(
                    item.shortDesc,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // - Updated food image: rounded + fixed size + cover
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 70,
              height: 70,
              color: Colors.white.withOpacity(0.9),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
