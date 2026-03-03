import 'package:flutter/material.dart';
import 'package:quick_menu/core/theme/app_colors.dart';

class SpecialOffersScreen extends StatelessWidget {
  const SpecialOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppGradients.headerGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🎉 Special Offers',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Limited Time Offer Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE05757), Color(0xFFF7971E)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Hot Deals',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Featured Offer
          _OfferCard(
            title: '🍔 Lunch Special',
            subtitle: 'Any Main Course + Drink',
            discount: '30% OFF',
            description: 'Valid from 12 PM - 3 PM',
            backgroundColor: Colors.orange.shade50,
            accentColor: Colors.orange,
            code: 'LUNCH30',
            validUntil: 'Valid Today',
          ),

          const SizedBox(height: 16),

          _OfferCard(
            title: '🍕 Weekend Feast',
            subtitle: 'Order 2 Large Pizzas',
            discount: 'Rs. 500 OFF',
            description: 'Valid on Saturdays & Sundays',
            backgroundColor: Colors.purple.shade50,
            accentColor: Colors.purple,
            code: 'WEEKEND500',
            validUntil: 'Valid This Weekend',
          ),

          const SizedBox(height: 16),

          _OfferCard(
            title: '🍰 Happy Hour',
            subtitle: 'All Desserts & Beverages',
            discount: '20% OFF',
            description: 'Valid from 4 PM - 6 PM',
            backgroundColor: Colors.pink.shade50,
            accentColor: Colors.pink,
            code: 'HAPPY20',
            validUntil: 'Valid Today',
          ),

          const SizedBox(height: 16),

          _OfferCard(
            title: '🎂 Birthday Special',
            subtitle: 'Show Your Birthday ID',
            discount: 'FREE Dessert',
            description: 'Valid on your birthday',
            backgroundColor: Colors.blue.shade50,
            accentColor: Colors.blue,
            code: 'BDAY',
            validUntil: 'Valid on Birthday',
          ),

          const SizedBox(height: 16),

          _OfferCard(
            title: '👥 Group Dining',
            subtitle: 'Orders Above Rs. 5000',
            discount: '15% OFF',
            description: 'Minimum 4 people',
            backgroundColor: Colors.green.shade50,
            accentColor: Colors.green,
            code: 'GROUP15',
            validUntil: 'Valid Anytime',
          ),

          const SizedBox(height: 16),

          _OfferCard(
            title: '🌟 First Order',
            subtitle: 'For New Customers',
            discount: '25% OFF',
            description: 'Valid on first order only',
            backgroundColor: Colors.amber.shade50,
            accentColor: Colors.amber.shade700,
            code: 'FIRST25',
            validUntil: 'One Time Use',
          ),

          const SizedBox(height: 24),

          // Terms and Conditions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TermItem('Offers cannot be combined'),
                _TermItem('Management reserves the right to modify offers'),
                _TermItem('Applicable on dine-in orders only'),
                _TermItem('Show coupon code at counter for validation'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _TermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String discount;
  final String description;
  final Color backgroundColor;
  final Color accentColor;
  final String code;
  final String validUntil;

  const _OfferCard({
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.description,
    required this.backgroundColor,
    required this.accentColor,
    required this.code,
    required this.validUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative corner
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coupon Code',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: accentColor.withOpacity(0.3),
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  code,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _copyCouponCode(context),
                                  child: Icon(
                                    Icons.copy,
                                    size: 14,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            validUntil,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
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
    );
  }

  void _copyCouponCode(BuildContext context) {
    // Copy to clipboard functionality would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon code "$code" copied!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
