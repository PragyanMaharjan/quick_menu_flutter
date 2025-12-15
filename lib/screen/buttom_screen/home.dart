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
    setState(() {
      _selectedIndex = index;
    });
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
        showUnselectedLabels: true,
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
// MODEL FOR FOOD ITEM
///////////////////////////////////////////////////////////
class FoodItem {
  final String title;
  final String subtitle;
  final String shortDesc;
  final String fullDesc;
  final String price;
  final String imagePath;

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

  // 6 ITEMS
  static const List<FoodItem> items = [
    FoodItem(
      title: "Family Combo",
      subtitle: "Perfect for whole family",
      shortDesc: "A delightful meal for family moments.",
      fullDesc:
      "Includes 2 pizzas, 1 large fries, 4 drinks and a dessert. Perfect for sharing with your loved ones.",
      price: "Rs. 899",
      imagePath: "assets/image/item1.jpg",
    ),
    FoodItem(
      title: "Chicken Chilli",
      subtitle: "Spicy & Crispy",
      shortDesc: "Crispy chicken tossed in chilli sauce.",
      fullDesc:
      "Juicy crispy chicken coated with spicy chilli sauce, onions and capsicum. Best with fried rice.",
      price: "Rs. 420",
      imagePath: "assets/image/item2.jpg",
    ),
    FoodItem(
      title: "BBQ Wings",
      subtitle: "Smoky & Juicy",
      shortDesc: "BBQ wings with extra dip.",
      fullDesc:
      "Smoky BBQ chicken wings served hot with mayo dip and fresh salad. Great for starters.",
      price: "Rs. 499",
      imagePath: "assets/image/item3.jpg",
    ),
    FoodItem(
      title: "Veg Momo",
      subtitle: "Steamed",
      shortDesc: "Soft momo with spicy achar.",
      fullDesc:
      "Steamed veg momo packed with fresh veggies and served with homemade spicy achar.",
      price: "Rs. 180",
      imagePath: "assets/image/item4.jpg",
    ),
    FoodItem(
      title: "Cold Coffee",
      subtitle: "Chilled Drink",
      shortDesc: "Creamy coffee with ice.",
      fullDesc:
      "Refreshing cold coffee blended with milk and ice, topped with cream for extra taste.",
      price: "Rs. 220",
      imagePath: "assets/image/item5.jpg",
    ),
    FoodItem(
      title: "Paneer Tikka",
      subtitle: "Grilled",
      shortDesc: "Spicy grilled paneer platter.",
      fullDesc:
      "Grilled paneer cubes with veggies and spices served with mint chutney. Perfect starter.",
      price: "Rs. 350",
      imagePath: "assets/image/item6.jpg",
    ),
  ];

  void _showDishDetails(BuildContext context, FoodItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      item.imagePath,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Price: ${item.price}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.fullDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE05757),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Later you can add cart logic here
                          Navigator.pop(context);
                        },
                        child: const Text("Add To Cart"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE05757), Color(0xFFF7971E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Scan, order, and enjoy delicious food in seconds.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "THIS IS MY DASHBOARD",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // LIST OF 6 ITEMS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: items
                  .map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: menuCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    description: item.shortDesc,
                    imagePath: item.imagePath,
                    onTap: () => _showDishDetails(context, item),
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
// MENU CARD WIDGET
///////////////////////////////////////////////////////////
Widget menuCard({
  required String title,
  required String subtitle,
  required String description,
  required String imagePath,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF56ab2f), Color(0xFFA8e063)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  );
}
