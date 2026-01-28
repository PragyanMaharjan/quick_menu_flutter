import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/widgets/mybutton.dart';
import 'package:quick_menu/core/widgets/mytextfield.dart';
import 'package:quick_menu/core/utils/snackbar_utils.dart';
import '../view_model/auth_view_model.dart';
import '../state/auth_state.dart';
import 'sigup_screen.dart';
import '../../../dashboard/presentation/pages/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController mail = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    mail.dispose();
    pass.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(email: mail.text, password: pass.text);

      final authState = ref.read(authViewModelProvider);

      if (authState.status == AuthStatus.authenticated) {
        SnackBarUtils.success(context, "Login successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else if (authState.status == AuthStatus.error) {
        SnackBarUtils.error(context, authState.errorMessage ?? "Login failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Icon(Icons.restaurant_menu, size: 80, color: Colors.red.shade700),
            const SizedBox(height: 20),
            Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Login to continue to your restaurant",
              style: TextStyle(color: Colors.red.shade300),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextformfield(
                    labelText: "Email",
                    hintText: "Enter your email",
                    controller: mail,
                    errorMessage: "Email is required",
                    prefixIcon: Icons.email,
                  ),
                  MyTextformfield(
                    labelText: "Password",
                    hintText: "Enter your password",
                    controller: pass,
                    errorMessage: "Password is required",
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    onPressed: isLoading ? null : _handleLogin,
                    text: isLoading ? "Logging in..." : "Log In",
                    buttonColor: Colors.red.shade700,
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}