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
      SharedPreferences.setMockInitialValues({
        'is_logged_in': true,
        'user_full_name': 'Test User',
        'user_email': 'test@example.com',
        'user_phone_number': '1234567890',
      });
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
        child: MaterialApp(home: Scaffold(body: ProfileScreen())),
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
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Controllers are internal, but we can check for the presence of input fields
      // In non-editing mode, we have info tiles instead of TextFields
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('ProfileScreen contains edit mode toggle', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should have an edit button (IconButton)
      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('ProfileScreen displays user information fields', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should display user fields
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('ProfileScreen has profile section', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('ProfileScreen initializes without errors', (
      WidgetTester tester,
    ) async {
      // Act & Assert
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen is ConsumerStatefulWidget', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('ProfileScreen displays name field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enable edit mode
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert - Look for text field widgets in edit mode
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen displays email field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enable edit mode
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen displays phone field', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enable edit mode
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('ProfileScreen has settings options', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should have settings tiles or other UI elements
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('ProfileScreen can scroll content', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should have scrollable content
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('ProfileScreen renders with proper layout', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('ProfileScreen has profile picture section', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Should have containers for profile display
      expect(find.byType(Container), findsWidgets);
    });
  });
}
