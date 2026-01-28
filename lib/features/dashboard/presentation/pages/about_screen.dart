import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo/Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('🍔', style: TextStyle(fontSize: 80)),
                ),
              ),
              const SizedBox(height: 24),

              // App Name & Tagline
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Quick Menu',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your favorite meals, delivered fast',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // About Section
              _buildSection(
                emoji: '📱',
                title: 'About Quick Menu',
                content:
                    'Quick Menu is a modern food delivery application designed to bring your favorite restaurants and meals right to your doorstep. We are committed to providing fast, reliable, and delicious food delivery services.',
              ),
              const SizedBox(height: 20),

              // Mission Section
              _buildSection(
                emoji: '🎯',
                title: 'Our Mission',
                content:
                    'To revolutionize the way people order and enjoy food by combining convenience, quality, and speed. We aim to connect hungry customers with their favorite restaurants seamlessly.',
              ),
              const SizedBox(height: 20),

              // Vision Section
              _buildSection(
                emoji: '✨',
                title: 'Our Vision',
                content:
                    'To become the most trusted and preferred food delivery platform, known for exceptional service, diverse restaurant partners, and delightful customer experiences.',
              ),
              const SizedBox(height: 20),

              // Features Section
              const Text(
                '🌟 Why Choose Quick Menu?',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureList(),
              const SizedBox(height: 32),

              // Contact Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📧 Get in Touch',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Email functionality can be added here
                            },
                            child: const Text(
                              'support@quickmenu.com',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          '+1 (555) 123-4567',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Version Info
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '© 2026 Quick Menu. All rights reserved.',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String emoji,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Fast & Reliable Delivery',
      'Wide Restaurant Selection',
      'Easy Ordering Process',
      'Secure Payments',
      'Real-time Order Tracking',
      'Loyalty Rewards Program',
    ];

    return Column(
      children: List.generate(features.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Text(
                features[index],
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
