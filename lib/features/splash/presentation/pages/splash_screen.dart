import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../../auth/presentation/pages/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Image.asset(
          "assets/image/jhasha_logo.jpg",
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
