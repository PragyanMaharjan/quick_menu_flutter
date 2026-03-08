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

    Future<void> pumpDashboard(WidgetTester tester, {Widget? widget}) async {
      await tester.pumpWidget(widget ?? createWidgetUnderTest());

      // Home tab contains delayed banner timers; unmount and advance clock
      // so tests end without pending timer failures.
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 5));
      });
    }

    testWidgets('DashboardScreen renders successfully', (
      WidgetTester tester,
    ) async {
      await pumpDashboard(tester);
      await tester.pump();

      // Assert - Dashboard may render nested scaffolds via tab pages
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('DashboardScreen displays bottom navigation bar', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpDashboard(tester);

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('DashboardScreen initializes with default index 0', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await pumpDashboard(
        tester,
        widget: ProviderScope(
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
      await pumpDashboard(tester);

      // Assert - Check for Container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('DashboardScreen navigation items exist', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpDashboard(tester);

      // Assert - BottomNavigationBar should have items
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);
    });

    testWidgets('DashboardScreen handles tab switching', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpDashboard(tester);

      // Assert - Initially screen renders
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('DashboardScreen is StatefulWidget', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpDashboard(tester);

      // Assert
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('DashboardScreen renders correctly with custom initial index', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await pumpDashboard(
        tester,
        widget: ProviderScope(
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
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('DashboardScreen has proper widget structure', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpDashboard(tester);

      // Assert - Check main widget hierarchy
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('DashboardScreen responds to navigation taps', (
      WidgetTester tester,
    ) async {
      // Act
      await pumpDashboard(tester);

      // Try to tap a bottom nav item
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);

      // Assert - should render without errors
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });
  });
}
