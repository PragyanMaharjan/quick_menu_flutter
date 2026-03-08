import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/app/app.dart';
import 'package:quick_menu/core/services/hive/hive_service.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    print('🚀 Starting app initialization...');

    final hiveService = HiveService();
    print('📦 Initializing Hive...');
    await hiveService.init();
    print('📂 Opening Hive boxes...');
    await hiveService.openboxes();
    print('✅ Hive initialized successfully');

    // Provide the initialized HiveService to Riverpod
    setHiveServiceInstance(hiveService);

    print('🔧 Loading SharedPreferences...');
    final sharedPreferences = await SharedPreferences.getInstance();
    print('✅ SharedPreferences loaded');

    print('🎬 Starting app...');
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const App(),
      ),
    );
    print('✅ App started successfully');
  } catch (e, stackTrace) {
    print('❌ Fatal error during initialization: $e');
    print('Stack trace: $stackTrace');

    // Try to show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.white, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    'App Initialization Error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$e',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
