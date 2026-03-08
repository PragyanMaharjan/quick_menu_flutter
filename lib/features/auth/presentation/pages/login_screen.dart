import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/widgets/mybutton.dart';
import 'package:quick_menu/core/widgets/mytextfield.dart';
import 'package:quick_menu/core/utils/snackbar_utils.dart';
import 'package:quick_menu/core/services/biometric_auth_service.dart';
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
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    print('🔑 Login: Checking biometric availability...');
    final biometricService = ref.read(biometricAuthServiceProvider);
    final isSupported = await biometricService.isBiometricSupported();
    final isEnabled = await biometricService.isBiometricEnabled();
    final hasCredentials = await biometricService.hasStoredCredentials();

    print(
      '🔑 Login: Supported=$isSupported, Enabled=$isEnabled, HasCredentials=$hasCredentials',
    );

    if (mounted) {
      setState(() {
        _biometricAvailable = isSupported;
        _biometricEnabled = isEnabled && hasCredentials;
      });

      print(
        '🔑 Login: Final _biometricAvailable=$_biometricAvailable, _biometricEnabled=$_biometricEnabled',
      );

      // Auto-trigger biometric login if enabled and has credentials
      if (_biometricEnabled && hasCredentials) {
        print('🔑 Login: Auto-triggering biometric login...');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _handleBiometricLogin();
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    print('🔑 Login: Starting biometric login...');
    final biometricService = ref.read(biometricAuthServiceProvider);

    try {
      final credentials = await biometricService.loginWithBiometric();

      print('🔑 Login: Credentials retrieved: ${credentials != null}');

      if (credentials != null) {
        print('🔑 Login: Logging in with retrieved credentials...');
        // Login with retrieved credentials
        await ref
            .read(authViewModelProvider.notifier)
            .login(
              email: credentials['email']!,
              password: credentials['password']!,
            );

        final authState = ref.read(authViewModelProvider);
        print('🔑 Login: Auth state: ${authState.status}');

        if (authState.status == AuthStatus.authenticated) {
          print('✅ Login: Biometric login successful!');
          if (mounted) {
            SnackBarUtils.success(context, "Biometric login successful!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          }
        } else if (authState.status == AuthStatus.error) {
          print('❌ Login: Auth error: ${authState.errorMessage}');
          final errorMessage = authState.errorMessage?.toLowerCase() ?? '';

          // Stored biometric credentials can become stale if password changed.
          if (errorMessage.contains('invalid credentials')) {
            await biometricService.disableBiometric();
            if (mounted) {
              setState(() {
                _biometricEnabled = false;
              });
            }
          }

          if (mounted) {
            SnackBarUtils.error(
              context,
              errorMessage.contains('invalid credentials')
                  ? 'Saved biometric credentials are outdated. Please login manually once and re-enable biometric.'
                  : authState.errorMessage ?? "Login failed",
            );
          }
        }
      } else {
        print('⚠️ Login: No credentials returned from biometric service');
      }
    } catch (e) {
      print('❌ Login: Error during biometric login: $e');
      if (mounted) {
        SnackBarUtils.error(context, "Biometric login failed: $e");
      }
    }
  }

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
                  if (_biometricAvailable && _biometricEnabled) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: isLoading ? null : _handleBiometricLogin,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade100,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: Colors.red.shade700,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Login with Fingerprint",
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
