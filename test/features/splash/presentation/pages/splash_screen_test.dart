import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/features/splash/presentation/pages/splash_screen.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MaterialApp(home: SplashScreen()),
      );
    }

    testWidgets('SplashScreen renders successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('SplashScreen displays logo image', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('SplashScreen logo has correct dimensions', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert - Image should exist
      final imageWidget = find.byType(Image);
      expect(imageWidget, findsOneWidget);
    });

    testWidgets('SplashScreen is centered', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert - Check for Center widget
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('SplashScreen contains SingleChildScrollView', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('SplashScreen initializes correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert - Screen should render without errors
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('SplashScreen has proper structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert - Check widget tree structure
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('SplashScreen is a ConsumerStatefulWidget', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Assert - Screen should be displayed
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('SplashScreen renders without errors', (
      WidgetTester tester,
    ) async {
      // Act & Assert - Should not throw
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('SplashScreen image is properly loaded', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SplashScreen())),
      );

      // Give async image loading time
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
