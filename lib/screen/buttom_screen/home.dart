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
                  fontWeight: FontWeight.w700, // Bold
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
                  fontWeight: FontWeight.w400, // Regular
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
          // HEADER
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE05757), Color(0xFFF7971E)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Jhasha effortless QR scanner",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700, // Bold
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Scan, order, and enjoy delicious food in seconds.",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "THIS IS MY DASHBOARD",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700, // Bold
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 16),

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
                  fontWeight: FontWeight.w700, // Bold title
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
