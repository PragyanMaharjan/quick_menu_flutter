import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import 'dart:io';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.environment['FLUTTER_TEST'] != 'true') {
      // Use addPostFrameCallback to ensure navigation happens after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkLoginStatus();
      });
    }
  }

  void _checkLoginStatus() async {
    try {
      // Wait for splash screen display
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final userSessionService = ref.read(userSessionServiceProvider);
      final isLoggedIn = userSessionService.isLoggedIn();

      print('🔍 Splash: isLoggedIn = $isLoggedIn');

      if (!mounted) return;

      if (isLoggedIn) {
        print('✅ Splash: Navigating to Dashboard');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        print('✅ Splash: Navigating to Login');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Splash Error: $e');
      print('Stack: $stackTrace');

      // Fallback to login screen on error
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image/jhasha_logo.jpg",
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                print('❌ Image load error: $error');
                return Container(
                  width: 150,
                  height: 150,
                  color: Colors.white,
                  child: const Icon(Icons.restaurant, size: 80),
                );
              },
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
