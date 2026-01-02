  import 'package:flutter/material.dart';
  import 'package:quick_menu/core/services/auth_hive_service.dart';

  import '../../../../core/utils/snackbar_utils.dart';
  import 'login_screen.dart';

  class SignupScreen extends StatefulWidget {
    const SignupScreen({super.key});

    @override
    State<SignupScreen> createState() => _SignupScreenState();
  }

  class _SignupScreenState extends State<SignupScreen> {
    static const Color primary = Color(0xFFE05757);

    final fullNameController = TextEditingController();
    final mobileController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final authService = AuthHiveService();

    @override
    void dispose() {
      fullNameController.dispose();
      mobileController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ✅ Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE05757), Color(0xFFF7971E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Sign up to continue.",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ✅ Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Full Name"),
                        _field(fullNameController, "Enter full name",
                            TextInputType.name),

                        const SizedBox(height: 14),

                        _label("Mobile Number"),
                        _field(mobileController, "Enter mobile number",
                            TextInputType.phone),

                        const SizedBox(height: 14),

                        _label("Email"),
                        _field(emailController, "Enter email",
                            TextInputType.emailAddress),

                        const SizedBox(height: 14),

                        _label("Password"),
                        _passwordField(passwordController, "Enter password"),

                        const SizedBox(height: 14),

                        _label("Confirm Password"),
                        _passwordField(
                            confirmPasswordController, "Confirm password"),

                        const SizedBox(height: 22),

                        // ✅ Sign Up Button (Hive)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () async {
                              final fullName = fullNameController.text.trim();
                              final mobile = mobileController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text;
                              final confirmPassword = confirmPasswordController.text;

                              if (fullName.isEmpty ||
                                  mobile.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty ||
                                  confirmPassword.isEmpty) {
                                SnackBarUtils.error(
                                  context,
                                  "Please fill up the details to continue",
                                );
                                return;
                              }

                              if (password != confirmPassword) {
                                SnackBarUtils.error(context, "Passwords do not match");
                                return;
                              }

                              final error = await authService.signup(
                                fullName: fullName,
                                email: email,
                                phoneNumber: mobile,
                                password: password,
                              );

                              if (!context.mounted) return; // ✅ THIS is what the lint wants

                              if (error != null) {
                                SnackBarUtils.error(context, error);
                                return;
                              }

                              SnackBarUtils.success(context, "✅ Account created successfully");

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },

                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ✅ Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  color: primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    }

    static Widget _label(String text) {
      return Text(
        text,
        style: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
        ),
      );
    }

    static Widget _field(
        TextEditingController controller,
        String hint,
        TextInputType keyboardType,
        ) {
      return TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.black45,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    static Widget _passwordField(TextEditingController controller, String hint) {
      return TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.black45,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
