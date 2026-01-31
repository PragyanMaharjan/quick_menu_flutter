import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import 'package:quick_menu/core/theme/app_colors.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/combo.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/drinks.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/maincourse_screen.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/popular.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/starter_screen.dart';

import '../../../../core/utils/snackbar_utils.dart';
import 'order_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildBody(),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return OrderScreen(
          onBrowseMenu: () => setState(() => _selectedIndex = 0),
        );
      case 2:
        return const ProfileScreen();
      default:
        return const DashboardScreen();
    }
  }
}

///////////////////////////////////////////////////////////
// MODEL
///////////////////////////////////////////////////////////
class FoodItem {
  final String title, subtitle, shortDesc, fullDesc, price;
  final String imagePath;

  const FoodItem({
    required this.title,
    required this.subtitle,
    required this.shortDesc,
    required this.fullDesc,
    required this.price,
    this.imagePath = 'assets/image/image.png',
  });
}

///////////////////////////////////////////////////////////
// HOME TAB
///////////////////////////////////////////////////////////
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  static const List<FoodItem> items = [
    FoodItem(
      title: "Family Combo",
      subtitle: "Perfect for whole family",
      shortDesc: "A delightful meal for family moments.",
      fullDesc:
          "Includes 2 pizzas, 1 large fries, 4 drinks and a dessert. Perfect for sharing.",
      price: "Rs. 899",
    ),
    FoodItem(
      title: "Chicken Chilli",
      subtitle: "Spicy & Crispy",
      shortDesc: "Crispy chicken tossed in chilli sauce.",
      fullDesc:
          "Juicy crispy chicken coated with spicy chilli sauce and capsicum.",
      price: "Rs. 420",
    ),
    FoodItem(
      title: "Butter Chicken Biryani",
      subtitle: "Aromatic & Tender",
      shortDesc: "Aromatic basmati rice layered with tender butter chicken.",
      fullDesc:
          "Premium basmati rice cooked with tender chicken in a rich butter and cream sauce with aromatic spices.",
      price: "Rs. 480",
    ),
    FoodItem(
      title: "Paneer Tikka",
      subtitle: "Grilled to Perfection",
      shortDesc: "Marinated cottage cheese grilled with tandoori spices.",
      fullDesc:
          "Soft paneer cubes marinated in yogurt and spices, grilled to perfection. Served with mint chutney.",
      price: "Rs. 320",
    ),
    FoodItem(
      title: "Garlic Naan",
      subtitle: "Soft & Fluffy",
      shortDesc: "Soft bread baked in tandoor with garlic butter.",
      fullDesc:
          "Traditional Indian bread brushed with garlic butter and baked in tandoor oven. Soft and delicious.",
      price: "Rs. 120",
    ),
    FoodItem(
      title: "Chocolate Lava Cake",
      subtitle: "Warm & Gooey",
      shortDesc: "Warm chocolate cake with melting center and ice cream.",
      fullDesc:
          "Warm, gooey chocolate cake with a molten center. Served with vanilla ice cream. Irresistible!",
      price: "Rs. 280",
    ),
  ];

  void _showDishDetails(BuildContext context, WidgetRef ref, FoodItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderMedium,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.fastfood_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.borderLight, height: 1),
                const SizedBox(height: 20),

                // Description
                const Text(
                  'About this dish',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.fullDesc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .addItem(
                            CartItem(
                              id: item.title,
                              name: item.title,
                              price: item.price,
                              icon: '🍽️',
                            ),
                          );
                      Navigator.pop(context);
                      SnackBarUtils.success(
                        context,
                        '✓ ${item.title} added to cart!',
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_rounded),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                  children: [
                    CategoryChip(
                      text: "Starter",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StarterScreen(),
                          ),
                        );
                      },
                    ),
                    CategoryChip(
                      text: "Main Course",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainCourseScreen(),
                          ),
                        );
                      },
                    ),
                    CategoryChip(
                      text: "Drinks",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DrinksScreen(),
                          ),
                        );
                      },
                    ),
                    CategoryChip(
                      text: "Popular",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PopularScreen(),
                          ),
                        );
                      },
                    ),
                    CategoryChip(
                      text: "Combo",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ComboScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
                        child: menuCard(
                          item: item,
                          onTap: () => _showDishDetails(context, ref, item),
                          onDescriptionTap: () =>
                              _showDishDetails(context, ref, item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
// CATEGORY CHIP WIDGET
///////////////////////////////////////////////////////////
class CategoryChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const CategoryChip({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
// MENU CARD
///////////////////////////////////////////////////////////
Widget menuCard({
  required FoodItem item,
  required VoidCallback onTap,
  required VoidCallback onDescriptionTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF56ab2f), Color(0xFFA8e063)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF56ab2f).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onDescriptionTap,
                  child: Text(
                    item.shortDesc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.price,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 75,
              height: 75,
              color: Colors.white.withOpacity(0.95),
              child: Image.asset(item.imagePath, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    ),
  );
}
