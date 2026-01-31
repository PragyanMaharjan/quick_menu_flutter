import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/features/auth/presentation/pages/login_screen.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late SharedPreferences sharedPreferences;
    late Directory tempDir;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();

      // Initialize Hive for testing
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(tempDir.path);

      // Register adapters if not already registered
      if (!Hive.isAdapterRegistered(AuthHiveModelAdapter().typeId)) {
        Hive.registerAdapter(AuthHiveModelAdapter());
      }
    });

    tearDown(() async {
      await Hive.close();
      await tempDir.delete(recursive: true);
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MaterialApp(home: LoginScreen()),
      );
    }

    testWidgets('LoginScreen renders successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });

    testWidgets('LoginScreen displays title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('LoginScreen displays form fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('LoginScreen displays login button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Log In'), findsWidgets);
    });

    testWidgets('LoginScreen displays signup link', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text("Don't have an account? Sign up"), findsWidgets);
    });

    testWidgets('LoginScreen has scrollable content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('LoginScreen has form widget', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('LoginScreen has column layout', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('LoginScreen has containers', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });
  });
}
