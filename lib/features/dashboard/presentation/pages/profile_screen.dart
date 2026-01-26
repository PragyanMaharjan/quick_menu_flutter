import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSessionService = ref.read(userSessionServiceProvider);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              // 🎨 CREATIVE HEADER WITH STATS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE05757), Color(0xFFF7971E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    // Header title with settings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "👤 My Profile",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Avatar
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage(
                          "assets/image/background.jpg",
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Name
                    const Text(
                      "Pragyan Maharjan",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "🌟 Gold Member",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📊 QUICK STATS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatCard(icon: "🛒", label: "Orders", value: "12"),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.shade200,
                      ),
                      _StatCard(icon: "💳", label: "Spent", value: "Rs. 5.2K"),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey.shade200,
                      ),
                      _StatCard(icon: "❤️", label: "Favorites", value: "8"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📝 CONTACT INFORMATION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📋 Contact Information",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    infoTile(
                      icon: Icons.phone,
                      label: "Phone",
                      value: "+977 98XXXXXXXX",
                      emoji: "📱",
                    ),
                    const SizedBox(height: 12),
                    infoTile(
                      icon: Icons.email,
                      label: "Email",
                      value: "yourmail@gmail.com",
                      emoji: "✉️",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🎯 PREFERENCES & SETTINGS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "⚙️ Preferences",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.notifications,
                      label: "Notifications",
                      emoji: "🔔",
                      trailing: Switch(
                        value: true,
                        onChanged: (_) {},
                        activeThumbColor: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SettingsTile(
                      icon: Icons.card_giftcard,
                      label: "Loyalty Points",
                      emoji: "🏆",
                      trailing: const Text(
                        "250 Pts",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📞 SUPPORT & HELP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "💬 Help & Support",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SettingsTile(
                      icon: Icons.help_outline,
                      label: "FAQs",
                      emoji: "❓",
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SettingsTile(
                      icon: Icons.mail_outline,
                      label: "Contact Us",
                      emoji: "📧",
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),

          // LOGOUT BUTTON
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              backgroundColor: const Color(0xFFE05757),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Logout",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await userSessionService.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget infoTile({
  required IconData icon,
  required String label,
  required String value,
  required String emoji,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE05757).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// 📊 Stat card widget
class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.w800,
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

// ⚙️ Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String emoji;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.emoji,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
