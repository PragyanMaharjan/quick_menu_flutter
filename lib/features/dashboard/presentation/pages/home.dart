import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import 'package:quick_menu/core/theme/app_colors.dart';
import 'package:quick_menu/core/widgets/promotional_banner.dart';
import 'package:quick_menu/core/services/shake_service.dart';
import 'package:quick_menu/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/combo.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/drinks.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/maincourse_screen.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/popular.dart';
import 'package:quick_menu/features/horizontal/presentation/pages/starter_screen.dart';
import 'package:quick_menu/features/offers/presentation/pages/special_offers_screen.dart';
import 'package:quick_menu/features/payment/presentation/pages/order_history_screen.dart';

import '../../../../core/utils/snackbar_utils.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import 'qr_scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;
  ShakeService? _shakeService;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _initializeShakeService();
  }

  /// Initialize shake detection service
  void _initializeShakeService() {
    print('🔔 Initializing ShakeService with optimal thresholds...');
    _shakeService = ShakeService(
      onShakeDetected: _showCallWaiterDialog,
      shakeThreshold: 2.4, // Optimal: ~2.4 gForce for normal shakes
      gForceDeltaThreshold: 0.7, // Optimal: ~0.7 for delta detection
      minimumShakeCount: 2, // Number of shakes to detect
      shakeWindowMs: 800, // Optimal: ~800ms time window
      cooldownSeconds: 1, // Optimal: ~1 second cooldown
    );
    _shakeService!.startListening();
    print('✅ ShakeService initialized with optimal settings');
  }

  /// Show confirmation dialog before calling waiter
  void _showCallWaiterDialog() {
    print('🔔 _showCallWaiterDialog called!');
    print('🔔 _selectedIndex: $_selectedIndex');
    print('🔔 mounted: $mounted');

    // Only trigger on home tab (index 0)
    if (_selectedIndex != 0) {
      print('⚠️ Not on home tab, skipping dialog');
      return;
    }

    if (!mounted) {
      print('⚠️ Widget not mounted, skipping dialog');
      return;
    }

    // Use WidgetsBinding to ensure dialog shows properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        print('⚠️ Widget no longer mounted when trying to show dialog');
        return;
      }

      print('✅ Showing call waiter dialog...');
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk,
                    color: Colors.orange,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Call Waiter?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              'Do you want to call a waiter to your table?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print('❌ Dialog canceled');
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _callWaiter();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Yes, Call',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ).catchError((e) {
        print('❌ Error showing dialog: $e');
      });
    });
  }

  /// Call waiter function - sends notification to staff
  void _callWaiter() {
    // TODO: Implement API call to notify restaurant staff
    // Example: await api.notifyWaiter(tableNumber: currentTable);

    print('🔔 Waiter called for table');

    // Show success feedback
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Waiter Notified!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'A staff member will be with you shortly',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _shakeService?.dispose();
    super.dispose();
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
    print('📱 _buildBody called with _selectedIndex: $_selectedIndex');

    switch (_selectedIndex) {
      case 0:
        print('📱 Creating HomeTab with onCallWaiter callback');
        // IMPORTANT: Remove const to allow dynamic callback
        return HomeTab(
          key: ValueKey('home_tab_$_selectedIndex'),
          onCallWaiter: _showCallWaiterDialog,
        );
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
  final VoidCallback? onCallWaiter;

  const HomeTab({super.key, this.onCallWaiter});

  static const List<FoodItem> items = [
    FoodItem(
      title: "Family Combo",
      subtitle: "Perfect for whole family",
      shortDesc: "A delightful meal for family moments.",
      fullDesc:
          "Includes 2 pizzas, 1 large fries, 4 drinks and a dessert. Perfect for sharing.",
      price: "Rs. 899",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
    FoodItem(
      title: "Chicken Chilli",
      subtitle: "Spicy & Crispy",
      shortDesc: "Crispy chicken tossed in chilli sauce.",
      fullDesc:
          "Juicy crispy chicken coated with spicy chilli sauce and capsicum.",
      price: "Rs. 420",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
    FoodItem(
      title: "Butter Chicken Biryani",
      subtitle: "Aromatic & Tender",
      shortDesc: "Rich and flavorful butter chicken biryani.",
      fullDesc:
          "Tender chicken pieces cooked with aromatic basmati rice, butter chicken masala, and saffron.",
      price: "Rs. 350",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
    FoodItem(
      title: "Paneer Tikka Masala",
      subtitle: "Creamy & Spicy",
      shortDesc: "Paneer cubes in rich tomato gravy.",
      fullDesc:
          "Soft paneer cubes marinated and cooked in a creamy tomato-based curry with Indian spices.",
      price: "Rs. 320",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
    FoodItem(
      title: "Veg Manchurian",
      subtitle: "Crispy & Tangy",
      shortDesc: "Vegetable dumplings in spicy sauce.",
      fullDesc:
          "Crispy vegetable balls tossed in a tangy and spicy Indo-Chinese sauce.",
      price: "Rs. 280",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
    FoodItem(
      title: "Fish Curry",
      subtitle: "Traditional & Spicy",
      shortDesc: "Fresh fish in coconut curry.",
      fullDesc:
          "Fresh fish fillets cooked in traditional Kerala-style coconut curry with tamarind and spices.",
      price: "Rs. 450",
      imagePath: "assets/image/chickenchilli.jpeg",
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCallback = onCallWaiter != null;
    print('🏠 ========================================');
    print('🏠 HomeTab.build() called');
    print('🏠 onCallWaiter callback: ${hasCallback ? "✅ PROVIDED" : "❌ NULL"}');
    print('🏠 ========================================');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Quick Menu',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.textHint),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for food...',
                        hintStyle: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Animated Promotional Banner
            const PromotionalBanner(),

            const SizedBox(height: 20),

            // Quick Access Row
            Row(
              children: [
                Expanded(
                  child: _QuickAccessCard(
                    icon: Icons.local_offer,
                    label: 'Offers',
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpecialOffersScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAccessCard(
                    icon: Icons.favorite,
                    label: 'Favorites',
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAccessCard(
                    icon: Icons.receipt_long,
                    label: 'History',
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderHistoryScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Helpful Info Card - Shake to Call Waiter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.phone_in_talk,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📲 Need Help?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Shake your phone firmly to call a waiter',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Scan Table QR Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _scanTableQr(context),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Table QR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categories
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryCard(
                    context,
                    'Popular',
                    Icons.star_rounded,
                    AppColors.primary,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PopularScreen(),
                      ),
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Starters',
                    Icons.restaurant_rounded,
                    AppColors.primaryLight,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StarterScreen(),
                      ),
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Main Course',
                    Icons.dinner_dining_rounded,
                    AppColors.success,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainCourseScreen(),
                      ),
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Drinks',
                    Icons.local_drink_rounded,
                    AppColors.primary,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrinksScreen(),
                      ),
                    ),
                  ),
                  _buildCategoryCard(
                    context,
                    'Combos',
                    Icons.fastfood_rounded,
                    AppColors.primaryLight,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComboScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recommended Items
            const Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildFoodItemCard(context, item, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetailModal(FoodItem item, WidgetRef ref) {
    return FractionallySizedBox(
      heightFactor: 0.85,
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
              // Handle
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

              // Image showcase
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey.shade100,
                    child: Image.asset(item.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Item details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and category
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Full Description
                    Text(
                      item.fullDesc,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Price and info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.price,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE05757),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade600,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Add to Cart button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Builder(
                    builder: (btnContext) => ElevatedButton(
                      onPressed: () {
                        final cartItem = CartItem(
                          id: item.title,
                          name: item.title,
                          price: item.price,
                          icon: item.imagePath,
                        );
                        ref.read(cartProvider.notifier).addItem(cartItem);
                        SnackBarUtils.showSnackBar(
                          btnContext,
                          '${item.title} added to cart',
                        );
                        Navigator.pop(btnContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE05757),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemCard(
    BuildContext context,
    FoodItem item,
    WidgetRef ref,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showFoodItemDetails(context, item, ref),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.shortDesc,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
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
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final cartItem = CartItem(
                          id: item.title,
                          name: item.title,
                          price: item.price,
                          icon: item.imagePath,
                        );
                        ref.read(cartProvider.notifier).addItem(cartItem);
                        SnackBarUtils.showSnackBar(
                          context,
                          '${item.title} added to cart',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.white.withOpacity(0.95),
                        child: Image.asset(item.imagePath, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFoodItemDetails(
    BuildContext context,
    FoodItem item,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _buildItemDetailModal(item, ref),
    );
  }

  void _scanTableQr(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (result != null) {
      // Show success message with table number
      SnackBarUtils.showSnackBar(context, 'Scanned successfully! $result');

      // Here you can navigate to a menu screen for the specific table
      // For now, we'll just show the table info
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Welcome!'),
          content: Text(
            'You are now viewing the menu for $result. Enjoy your meal!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

// Quick Access Card Widget
class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
