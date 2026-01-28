import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/widgets/mybutton.dart';
import 'package:quick_menu/core/widgets/mytextfield.dart';
import 'package:quick_menu/core/utils/snackbar_utils.dart';
import 'package:quick_menu/core/utils/validators.dart';
import '../view_model/auth_view_model.dart';
import '../state/auth_state.dart';
import 'login_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    number.dispose();
    password.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .register(
            fullName: name.text,
            email: email.text,
            phoneNumber: number.text,
            password: password.text,
          );

      final authState = ref.read(authViewModelProvider);

      if (authState.status == AuthStatus.registered) {
        SnackBarUtils.success(context, "Registered successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else if (authState.status == AuthStatus.error) {
        SnackBarUtils.error(
          context,
          authState.errorMessage ?? "Registration failed",
        );
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
            const SizedBox(height: 60),
            Icon(Icons.restaurant, size: 80, color: Colors.red.shade700),
            const SizedBox(height: 20),
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Join our restaurant community",
              style: TextStyle(color: Colors.red.shade300),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  MyTextformfield(
                    labelText: "Name",
                    hintText: "Enter full name",
                    controller: name,
                    errorMessage: "Name is required",
                    validator: Validators.validateName,
                    prefixIcon: Icons.person,
                  ),
                  MyTextformfield(
                    labelText: "Email",
                    hintText: "Enter email",
                    controller: email,
                    errorMessage: "Email is required",
                    validator: Validators.validateEmail,
                    prefixIcon: Icons.email,
                  ),
                  MyTextformfield(
                    labelText: "Phone Number",
                    hintText: "Enter phone number",
                    controller: number,
                    errorMessage: "Phone number is required",
                    validator: Validators.validatePhoneNumber,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                  MyTextformfield(
                    labelText: "Password",
                    hintText: "Enter password",
                    controller: password,
                    errorMessage: "Password is required",
                    validator: Validators.validatePassword,
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onPressed: isLoading ? null : _handleSignup,
                    text: isLoading ? "Creating..." : "Sign Up",
                    buttonColor: Colors.red.shade700,
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
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
