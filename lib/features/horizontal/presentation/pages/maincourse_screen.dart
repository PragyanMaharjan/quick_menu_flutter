import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';

/// 🍛 Main Course Screen - Heart of Your Feast
class MainCourseScreen extends ConsumerStatefulWidget {
  const MainCourseScreen({super.key});

  @override
  ConsumerState<MainCourseScreen> createState() => _MainCourseScreenState();
}

class _MainCourseScreenState extends ConsumerState<MainCourseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const List<MainCourseItem> vegetarianCourses = [
    MainCourseItem(
      name: "Paneer Butter Masala",
      description: "Creamy tomato sauce with tender paneer cubes",
      price: "Rs. 350",
      icon: "🟡",
      imagePath: "assets/image/paneer_butter_masala.jpeg",
      spiceLevel: 2,
      protein: "Paneer",
      servings: 2,
    ),
    MainCourseItem(
      name: "Chana Masala",
      description: "Chickpeas in aromatic tomato-based gravy",
      price: "Rs. 280",
      icon: "🔴",
      imagePath: "assets/image/chana_masala.jpeg",
      spiceLevel: 3,
      protein: "Chickpea",
      servings: 2,
    ),
  ];

  static const List<MainCourseItem> nonVegCourses = [
    MainCourseItem(
      name: "Butter Chicken",
      description: "Tender chicken in creamy tomato cream sauce",
      price: "Rs. 420",
      icon: "🍗",
      imagePath: "assets/image/butter_chicken.jpeg",
      spiceLevel: 2,
      protein: "Chicken",
      servings: 2,
    ),
    MainCourseItem(
      name: "Tandoori Chicken",
      description: "Marinated & grilled chicken with spicy marinade",
      price: "Rs. 450",
      icon: "🔥",
      imagePath: "assets/image/tandoori_chicken.jpeg",
      spiceLevel: 4,
      protein: "Chicken",
      servings: 2,
    ),
    MainCourseItem(
      name: "Lamb Biryani",
      description: "Fragrant rice with tender lamb meat",
      price: "Rs. 520",
      icon: "🎋",
      imagePath: "assets/image/lamb_biryani.jpeg",
      spiceLevel: 3,
      protein: "Lamb",
      servings: 3,
    ),
  ];

  void _addToCart(MainCourseItem item) {
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
  }

  void _showCourseDetails(BuildContext context, MainCourseItem item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🎨 Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFE05757), const Color(0xFFF7971E)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(item.icon, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🖼️ Image showcase
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey.shade100,
                  child: Image.asset(item.imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 18),

              // 📝 Description
              Text(
                item.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // 📊 Course details grid
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _InfoBadge(
                      icon: "🌶️",
                      label: "Spice",
                      value: "${"🌶️" * item.spiceLevel}/5",
                    ),
                    _InfoBadge(
                      icon: "🍗",
                      label: "Protein",
                      value: item.protein,
                    ),
                    _InfoBadge(
                      icon: "🍽️",
                      label: "Serves",
                      value: "${item.servings} people",
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
                      color: const Color(0xFFF7971E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.price,
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF7971E),
                      ),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addToCart(item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE05757),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "🛒 Add",
                      style: TextStyle(color: Colors.white),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 240,
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("🍛", style: TextStyle(fontSize: 48)),
                      const Text(
                        "Main Courses",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Satisfy your cravings with our signature dishes",
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "🌱 Vegetarian"),
                    Tab(text: "🍗 Non-Veg"),
                    Tab(text: "📦 Combos"),
                  ],
                  labelStyle: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  labelColor: const Color(0xFFE05757),
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: const Color(0xFFE05757),
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // 🌱 Vegetarian
            _CourseListView(
              courses: vegetarianCourses,
              onTap: (item) => _showCourseDetails(context, item),
            ),

            // 🍗 Non-Vegetarian
            _CourseListView(
              courses: nonVegCourses,
              onTap: (item) => _showCourseDetails(context, item),
            ),

            // 📦 Combos
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🎉", style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    const Text(
                      "Combo Deals Coming Soon!",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Get amazing discounts when you bundle your favorites",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseListView extends StatelessWidget {
  final List<MainCourseItem> courses;
  final Function(MainCourseItem) onTap;

  const _CourseListView({required this.courses, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final item = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _MainCourseCard(item: item, onTap: () => onTap(item)),
        );
      },
    );
  }
}

class _MainCourseCard extends StatelessWidget {
  final MainCourseItem item;
  final VoidCallback onTap;

  const _MainCourseCard({required this.item, required this.onTap});

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
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              // 🖼️ Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Container(
                  width: 100,
                  height: 120,
                  color: Colors.grey.shade100,
                  child: Image.asset(item.imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),

              // 📝 Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(item.icon, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.name,
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
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.price,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF7971E),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 🎯 Action button
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
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

class MainCourseItem {
  final String name;
  final String description;
  final String price;
  final String icon;
  final String imagePath;
  final int spiceLevel;
  final String protein;
  final int servings;

  const MainCourseItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imagePath,
    required this.spiceLevel,
    required this.protein,
    required this.servings,
  });
}
