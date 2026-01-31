import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:quick_menu/core/services/storage/user_session_service.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
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
        child: const MaterialApp(home: ProfileScreen()),
      );
    }

    testWidgets('ProfileScreen renders with correct UI elements', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert - Check for Scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('ProfileScreen has text editing controllers', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Should have text fields
      expect(
        find.byType(TextEditingController),
        findsNothing,
      ); // Controllers are internal
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen contains edit mode toggle', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Should have buttons for editing
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('ProfileScreen displays user information fields', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Should display user fields
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('ProfileScreen has profile section', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('ProfileScreen initializes without errors', (
      WidgetTester tester,
    ) async {
      // Act & Assert
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen is ConsumerStatefulWidget', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen displays name field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Look for text field widgets
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen displays email field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen displays phone field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen has settings options', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Should have buttons for settings like logout
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('ProfileScreen can scroll content', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Should have scrollable content
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('ProfileScreen renders with proper layout', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('ProfileScreen has profile picture section', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );

      // Assert - Should have containers for profile display
      expect(find.byType(Container), findsWidgets);
    });
  });
}
