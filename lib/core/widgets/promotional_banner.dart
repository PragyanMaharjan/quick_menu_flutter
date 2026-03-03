import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated promotional banner widget for the home screen
class PromotionalBanner extends StatefulWidget {
  const PromotionalBanner({super.key});

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  int _currentBannerIndex = 0;

  final List<BannerData> _banners = [
    BannerData(
      title: '🎉 30% OFF',
      subtitle: 'Lunch Special',
      gradient: const LinearGradient(
        colors: [Color(0xFFE05757), Color(0xFFF7971E)],
      ),
      icon: '🍔',
    ),
    BannerData(
      title: '⭐ New Menu',
      subtitle: 'Try Our Latest Dishes',
      gradient: const LinearGradient(
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
      ),
      icon: '🍕',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Auto-rotate banners
    Future.delayed(const Duration(seconds: 4), _rotateBanner);
  }

  void _rotateBanner() {
    if (mounted) {
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _banners.length;
      });
      Future.delayed(const Duration(seconds: 4), _rotateBanner);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentBanner = _banners[_currentBannerIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(_currentBannerIndex),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: 170,
        decoration: BoxDecoration(
          gradient: currentBanner.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              right: -30,
              top: -30,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.2 - (_scaleAnimation.value - 0.95) * 2,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentBanner.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          currentBanner.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * math.pi,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              currentBanner.icon,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Indicator dots
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _banners.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _currentBannerIndex ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        index == _currentBannerIndex ? 1 : 0.4,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannerData {
  final String title;
  final String subtitle;
  final Gradient gradient;
  final String icon;

  BannerData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });
}
