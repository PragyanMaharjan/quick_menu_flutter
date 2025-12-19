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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFE05757),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Order"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
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
      imagePath: "assets/image/background.jpg",
    ),
    FoodItem(
      title: "Chicken Chilli",
      subtitle: "Spicy & Crispy",
      shortDesc: "Crispy chicken tossed in chilli sauce.",
      fullDesc:
      "Juicy crispy chicken coated with spicy chilli sauce and capsicum.",
      price: "Rs. 420",
      imagePath: "assets/image/background.jpg",
    ),
  ];

  void _showDishDetails(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(item.imagePath, height: 140),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Price: ${item.price}",
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.fullDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                ),
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
          // ✅ FULL-WIDTH HEADER (edge-to-edge)
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

          // ✅ HORIZONTAL CATEGORY BUTTONS
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                CategoryChip(text: "Starter"),
                CategoryChip(text: "Main Course"),
                CategoryChip(text: "Drinks"),
                CategoryChip(text: "Popular"),
                CategoryChip(text: "Combo"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ✅ MENU LIST
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: items
                  .map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _showDishDetails(context, item),
                    child: menuCard(item),
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
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
// MENU CARD
///////////////////////////////////////////////////////////
Widget menuCard(FoodItem item) {
  return Container(
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
              Text(
                item.shortDesc,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Image.asset(item.imagePath, height: 60),
      ],
    ),
  );
}
