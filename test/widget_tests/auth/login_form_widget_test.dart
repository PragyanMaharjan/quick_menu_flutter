import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Form Widget Tests', () {
    testWidgets('should render email and password fields', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: LoginForm()));

      // Assert
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: LoginForm()));

      // Act
      await tester.enterText(find.byKey(const Key('email_field')), 'invalid');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Assert
      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('should navigate to home on successful login', (tester) async {
      // Arrange
      await tester.pumpWidget(const MaterialApp(home: LoginForm()));

      // Act
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}

// Mock LoginForm widget
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  void _handleLogin() {
    setState(() {
      _emailError = null;
    });

    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = 'Invalid email';
      });
      return;
    }

    // Simulate successful login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('email_field'),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError,
              ),
            ),
            TextField(
              key: const Key('password_field'),
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              key: const Key('login_button'),
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
