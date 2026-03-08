import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:quick_menu/features/horizontal/presentation/pages/maincourse_screen.dart';
import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';

void main() {
  group('MenuItemScreen Widget Tests', () {
    late Directory tempDir;

    setUp(() async {
      // Initialize Hive for testing
      tempDir = await Directory.systemTemp.createTemp('hive_menu_test_');
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
      return ProviderScope(child: const MaterialApp(home: MainCourseScreen()));
    }

    testWidgets('MaincourseScreen renders successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('MaincourseScreen displays app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('MaincourseScreen has gridview or listview for items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final hasGridView = find.byType(GridView).evaluate().isNotEmpty;
      final hasListView = find.byType(ListView).evaluate().isNotEmpty;

      expect(
        hasGridView || hasListView,
        true,
        reason: 'Screen should have GridView or ListView',
      );
    });

    testWidgets('MaincourseScreen displays all three tabs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('🌱 Vegetarian'), findsOneWidget);
      expect(find.text('🍗 Non-Veg'), findsOneWidget);
      expect(find.text('📦 Combos'), findsOneWidget);
    });

    testWidgets('MaincourseScreen shows vegetarian items by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Paneer Butter Masala'), findsOneWidget);
      expect(find.text('Chana Masala'), findsOneWidget);
    });

    testWidgets('MaincourseScreen switches to non-veg tab content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('🍗 Non-Veg'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Butter Chicken'), findsOneWidget);
      expect(find.text('Tandoori Chicken'), findsOneWidget);
    });

    testWidgets('MaincourseScreen shows combo placeholder on combo tab', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('📦 Combos'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Combo Deals Coming Soon!'), findsOneWidget);
    });

    testWidgets('MaincourseScreen opens item details dialog on card tap', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Paneer Butter Masala'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}
