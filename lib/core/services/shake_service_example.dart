/// SHAKE SERVICE - USAGE EXAMPLE
///
/// This file demonstrates how to use ShakeService in any Flutter widget.
/// Production-ready implementation for restaurant mobile app.

import 'package:flutter/material.dart';
import 'package:quick_menu/core/services/shake_service.dart';

/// Example 1: Basic Integration in StatefulWidget
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  ShakeService? _shakeService;

  @override
  void initState() {
    super.initState();
    _initializeShakeService();
  }

  /// Initialize shake detection service
  void _initializeShakeService() {
    _shakeService = ShakeService(
      onShakeDetected: _showCallWaiterDialog,
      shakeThreshold: 2.9, // Deliberate shake only
      minimumShakeCount: 2, // Require 2 shakes
      shakeWindowMs: 750, // Within 750ms
      cooldownSeconds: 3, // 3 second cooldown
    );
    _shakeService!.startListening();
    print('✅ Shake service initialized');
  }

  /// Show confirmation dialog before calling waiter
  void _showCallWaiterDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.phone_in_talk,
                  color: Colors.orange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Call Waiter?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Do you want to call a waiter to your table?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _callWaiter();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Yes, Call',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Call waiter function - sends notification to restaurant staff
  void _callWaiter() {
    // TODO: Replace with your API call
    // Example:
    // await RestaurantApi.notifyWaiter(
    //   tableNumber: currentTableNumber,
    //   customerId: userId,
    // );

    print('🔔 Waiter called successfully');

    // Show success feedback
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Waiter Notified!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'A staff member will be with you shortly',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    // IMPORTANT: Always dispose shake service to prevent memory leaks
    _shakeService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Our Restaurant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.phone_in_talk, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Shake your phone firmly to call a waiter',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 2: Custom Configuration
class AdvancedShakeExample extends StatefulWidget {
  const AdvancedShakeExample({super.key});

  @override
  State<AdvancedShakeExample> createState() => _AdvancedShakeExampleState();
}

class _AdvancedShakeExampleState extends State<AdvancedShakeExample> {
  ShakeService? _shakeService;

  @override
  void initState() {
    super.initState();
    _initializeCustomShakeService();
  }

  void _initializeCustomShakeService() {
    _shakeService = ShakeService(
      onShakeDetected: () {
        print('🎯 Custom shake detected!');
        _handleCustomAction();
      },
      shakeThreshold: 2.8, // Lower = more sensitive
      minimumShakeCount: 2, // Require 2 consecutive shakes
      shakeWindowMs: 700, // Within 700ms
      cooldownSeconds: 3, // 3 second cooldown
    );
    _shakeService!.startListening();
  }

  void _handleCustomAction() {
    if (!mounted) return;
    // Your custom action here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shake Detected!'),
        content: const Text('Custom action triggered'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _shakeService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Shake Example')),
      body: const Center(
        child: Text('Shake phone to test custom configuration'),
      ),
    );
  }
}

/// Example 3: Enable/Disable Shake Detection
class ToggleableShakeExample extends StatefulWidget {
  const ToggleableShakeExample({super.key});

  @override
  State<ToggleableShakeExample> createState() => _ToggleableShakeExampleState();
}

class _ToggleableShakeExampleState extends State<ToggleableShakeExample> {
  ShakeService? _shakeService;
  bool _isShakeEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeShakeService();
  }

  void _initializeShakeService() {
    _shakeService = ShakeService(
      onShakeDetected: () => print('Shake detected!'),
    );
    _shakeService!.startListening();
  }

  void _toggleShakeDetection(bool enabled) {
    setState(() {
      _isShakeEnabled = enabled;
      if (enabled) {
        _shakeService?.startListening();
      } else {
        _shakeService?.stopListening();
      }
    });
  }

  @override
  void dispose() {
    _shakeService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toggleable Shake')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Enable Shake Detection'),
          subtitle: const Text('Toggle shake-to-call feature'),
          value: _isShakeEnabled,
          onChanged: _toggleShakeDetection,
        ),
      ),
    );
  }
}
