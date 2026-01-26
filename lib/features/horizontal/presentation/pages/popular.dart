import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/providers/cart_provider.dart';
import '../../../../core/utils/snackbar_utils.dart';

/// ⭐ Popular Screen - Most Loved Items
class PopularScreen extends ConsumerStatefulWidget {
  const PopularScreen({super.key});

  @override
  ConsumerState<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends ConsumerState<PopularScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  static const List<PopularItem> mostOrdered = [
    PopularItem(
      name: "Butter Chicken Biryani",
      category: "Main Course",
      price: "Rs. 480",
      icon: "👑",
      imagePath: "assets/image/butter_chicken_biryani.jpeg",
      rating: 4.9,
      reviews: 1250,
      popularityScore: 98,
      description: "Aromatic basmati rice layered with tender butter chicken",
    ),
    PopularItem(
      name: "Tandoori Paneer Pizza",
      category: "Main Course",
      price: "Rs. 420",
      icon: "🍕",
      imagePath: "assets/image/tandoori_paneer_pizza.jpeg",
      rating: 4.8,
      reviews: 980,
      popularityScore: 95,
      description: "Crispy crust with tandoori paneer and fresh veggies",
    ),
    PopularItem(
      name: "Chocolate Lava Cake",
      category: "Dessert",
      price: "Rs. 280",
      icon: "🍰",
      imagePath: "assets/image/chocolate_lava.jpeg",
      rating: 4.9,
      reviews: 2100,
      popularityScore: 99,
      description: "Warm, gooey chocolate center with vanilla ice cream",
    ),
  ];

  static const List<PopularItem> trending = [
    PopularItem(
      name: "Vietnamese Pho",
      category: "Asian",
      price: "Rs. 350",
      icon: "🍜",
      imagePath: "assets/image/vietnamese_pho.jpeg",
      rating: 4.7,
      reviews: 450,
      popularityScore: 85,
      description: "Aromatic broth with rice noodles and fresh herbs",
    ),
    PopularItem(
      name: "Crispy Fish Tacos",
      category: "Mexican",
      price: "Rs. 380",
      icon: "🌮",
      imagePath: "assets/image/fish_tacos.jpeg",
      rating: 4.6,
      reviews: 320,
      popularityScore: 88,
      description: "Grilled fish with lime, cabbage slaw and chipotle mayo",
    ),
    PopularItem(
      name: "Truffle Mac & Cheese",
      category: "Western",
      price: "Rs. 420",
      icon: "🧀",
      imagePath: "assets/image/truffle_mac.jpeg",
      rating: 4.8,
      reviews: 580,
      popularityScore: 92,
      description: "Creamy pasta with three cheeses and truffle oil",
    ),
  ];

  void _addToCart(PopularItem item) {
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

  void _toggleFavorite(PopularItem item) {
    SnackBarUtils.success(context, "❤️ Added to favorites!");
  }

  void _showItemDetails(BuildContext context, PopularItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
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

                // 🖼️ Large image showcase
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

                // 📝 Item details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with emoji
                      Row(
                        children: [
                          Text(item.icon, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                                    item.category,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        item.description,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatBox(
                              icon: "⭐",
                              value: "${item.rating}",
                              label: "Rating",
                            ),
                            _StatBox(
                              icon: "💬",
                              value: "${item.reviews}",
                              label: "Reviews",
                            ),
                            _StatBox(
                              icon: "🔥",
                              value: "${item.popularityScore}%",
                              label: "Popular",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Popularity bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Popularity",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "${item.popularityScore}%",
                                style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: item.popularityScore / 100,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Price and buttons
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.price,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _toggleFavorite(item);
                            },
                            icon: const Icon(
                              Icons.favorite_outline,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _addToCart(item);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              minimumSize: const Size(100, 50),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.orange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade700, Colors.amber.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("⭐", style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      "Popular Picks",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Most loved by our customers",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
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
                    Tab(text: "🏆 Most Ordered"),
                    Tab(text: "🔥 Trending"),
                  ],
                  labelStyle: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: Colors.orange,
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // 🏆 Most Ordered
            _PopularListView(
              items: mostOrdered,
              onItemTap: (item) => _showItemDetails(context, item),
            ),

            // 🔥 Trending
            _PopularListView(
              items: trending,
              onItemTap: (item) => _showItemDetails(context, item),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularListView extends StatelessWidget {
  final List<PopularItem> items;
  final Function(PopularItem) onItemTap;

  const _PopularListView({required this.items, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PopularCard(
            item: item,
            onTap: () => onItemTap(item),
            index: index,
          ),
        );
      },
    );
  }
}

class _PopularCard extends StatelessWidget {
  final PopularItem item;
  final VoidCallback onTap;
  final int index;

  const _PopularCard({
    required this.item,
    required this.onTap,
    required this.index,
  });

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
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // 🎖️ Ranking badge + Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Container(
                      width: 110,
                      height: 130,
                      color: Colors.grey.shade100,
                      child: Image.asset(item.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  // Ranking badge
                  Positioned(
                    top: 8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRankColor(index),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "#${index + 1}",
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "${item.rating} (${item.reviews})",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Price
                      Text(
                        item.price,
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 🎯 Arrow
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

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.orange;
      default:
        return Colors.orange;
    }
  }
}

class _StatBox extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PopularItem {
  final String name;
  final String category;
  final String price;
  final String icon;
  final String imagePath;
  final double rating;
  final int reviews;
  final int popularityScore;
  final String description;

  const PopularItem({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.imagePath,
    required this.rating,
    required this.reviews,
    required this.popularityScore,
    required this.description,
  });
}
