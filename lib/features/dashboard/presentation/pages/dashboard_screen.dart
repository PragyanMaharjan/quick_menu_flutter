import 'package:flutter/material.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/home.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/order_screen.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:quick_menu/core/services/shake_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  ShakeService? _shakeService;

  @override
  void initState() {
    super.initState();
    _initializeShakeService();
  }

  @override
  void dispose() {
    _shakeService?.stopListening();
    super.dispose();
  }

  /// Initialize shake detection service
  void _initializeShakeService() {
    print('🔔 Initializing ShakeService with optimal thresholds...');
    _shakeService = ShakeService(
      onShakeDetected: _showCallWaiterDialog,
      shakeThreshold: 2.4, // Optimal: ~2.4 gForce for normal shakes
      gForceDeltaThreshold: 0.7, // Optimal: ~0.7 for delta detection
      minimumShakeCount: 2, // Number of shakes to detect
      shakeWindowMs: 800, // Optimal: ~800ms time window
      cooldownSeconds: 1, // Optimal: ~1 second cooldown
    );
    _shakeService?.startListening();
    print('✅ ShakeService initialized with optimal settings');
  }

  /// Show call waiter dialog when shake is detected
  void _showCallWaiterDialog() {
    print('📱 Shake detected! Attempting to show dialog...');

    // Check if widget is still mounted
    if (!mounted) {
      print('❌ Widget not mounted, cannot show dialog');
      return;
    }

    // Use WidgetsBinding to ensure dialog shows properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      print('📱 Showing call waiter dialog...');
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.notifications_active, color: Color(0xFFE05757)),
                SizedBox(width: 8),
                Text('Call Waiter'),
              ],
            ),
            content: const Text(
              'A waiter has been notified and will be with you shortly.',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print('✅ Dialog dismissed');
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFFE05757), fontSize: 16),
                ),
              ),
            ],
          );
        },
      ).catchError((e) {
        print('❌ Error showing dialog: $e');
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeTab(onCallWaiter: _showCallWaiterDialog),
            const OrderScreen(),
            const ProfileScreen(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFE05757),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Order",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
