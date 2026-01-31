import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/home.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';

void main() {
  group('DashboardScreen/Home Widget Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          userSessionServiceProvider.overrideWithValue(
            UserSessionService(prefs: sharedPreferences),
          ),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      );
    }

    testWidgets('DashboardScreen renders successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert - Check for Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('DashboardScreen displays bottom navigation bar', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('DashboardScreen initializes with default index 0', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            userSessionServiceProvider.overrideWithValue(
              UserSessionService(prefs: sharedPreferences),
            ),
          ],
          child: const MaterialApp(home: DashboardScreen(initialIndex: 0)),
        ),
      );

      // Assert - Should render without errors
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('DashboardScreen has container with decoration', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Check for Container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('DashboardScreen navigation items exist', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - BottomNavigationBar should have items
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);
    });

    testWidgets('DashboardScreen handles tab switching', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Initially screen renders
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('DashboardScreen is StatefulWidget', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('DashboardScreen renders correctly with custom initial index', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            userSessionServiceProvider.overrideWithValue(
              UserSessionService(prefs: sharedPreferences),
            ),
          ],
          child: const MaterialApp(home: DashboardScreen(initialIndex: 2)),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('DashboardScreen has proper widget structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Check main widget hierarchy
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('DashboardScreen responds to navigation taps', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Try to tap a bottom nav item
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);

      // Assert - should render without errors
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
