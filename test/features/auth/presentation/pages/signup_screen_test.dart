import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_menu/features/auth/presentation/pages/sigup_screen.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';
import 'dart:io';

import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';

void main() {
  group('SignupScreen Widget Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      // Initialize Hive for testing
      final tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);

      // Register adapters only if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(AuthHiveModelAdapter());
      }

      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    tearDown(() async {
      await Hive.close();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MaterialApp(home: SignupScreen()),
      );
    }

    testWidgets('SignupScreen renders successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });

    testWidgets('SignupScreen displays title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('SignupScreen displays form fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('SignupScreen displays signup button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsWidgets);
    });

    testWidgets('SignupScreen displays login link', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Already have an account? Login'), findsWidgets);
    });

    testWidgets('SignupScreen has scrollable content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('SignupScreen has form widget', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('SignupScreen has column layout', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('SignupScreen has containers', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });
  });
}
