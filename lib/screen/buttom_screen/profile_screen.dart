import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE05757),
                    Color(0xFFF7971E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Stack(
                children: [
                  // Title
                  const Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w600, // ✅ SemiBold
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Settings Icon
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PROFILE CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Photo
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: const AssetImage(
                        "assets/image/background.jpg",
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name
                  const Text(
                    "Pragyan Maharjan",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 22,
                      fontWeight: FontWeight.w600, // ✅ SemiBold
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info cards
                  infoTile(
                    icon: Icons.phone,
                    label: "Phone",
                    value: "+977 98XXXXXXXX",
                  ),
                  const SizedBox(height: 12),
                  infoTile(
                    icon: Icons.email,
                    label: "Email",
                    value: "yourmail@gmail.com",
                  ),
                ],
              ),
            ),
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
                fontWeight: FontWeight.w600, // ✅ SemiBold
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget infoTile({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE05757).withOpacity(0.15),
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
                label,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600, // ✅ SemiBold
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // ✅ SemiBold
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
