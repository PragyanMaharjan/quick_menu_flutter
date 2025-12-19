import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFE05757),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _settingTile(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: "Enable/Disable notifications",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _settingTile(
              icon: Icons.lock,
              title: "Privacy",
              subtitle: "Manage privacy options",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _settingTile(
              icon: Icons.palette,
              title: "Theme",
              subtitle: "Change app theme",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _settingTile(
              icon: Icons.help,
              title: "Help & Support",
              subtitle: "Get help and contact support",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _settingTile(
              icon: Icons.info,
              title: "About",
              subtitle: "App version and info",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE05757).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFFE05757)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
