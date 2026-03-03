import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for BiometricAuthService
final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

/// Service to handle biometric authentication (Fingerprint/Face ID)
class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys for storing data
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _storedEmailKey = 'biometric_email';
  static const String _storedPasswordKey = 'biometric_password';

  /// Check if device supports biometric authentication
  Future<bool> isBiometricSupported() async {
    try {
      print('🔒 Checking biometric support...');
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      print('🔒 canCheckBiometrics: $canCheckBiometrics');
      print('🔒 isDeviceSupported: $isDeviceSupported');
      print('🔒 availableBiometrics: $availableBiometrics');

      // Check if device has enrolled biometrics
      if (availableBiometrics.isEmpty) {
        print('⚠️ No biometrics enrolled on device');
        print('⚠️ User needs to add fingerprint in device settings');
      }

      final isSupported = canCheckBiometrics && availableBiometrics.isNotEmpty;
      print('🔒 Final support status: $isSupported');

      return isSupported;
    } catch (e) {
      print('❌ Error checking biometric support: $e');
      return false;
    }
  }

  /// Get available biometric types (Fingerprint, Face, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Check if biometric is enabled for this app
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      print('Error checking if biometric is enabled: $e');
      return false;
    }
  }

  /// Enable biometric authentication and store credentials securely
  Future<bool> enableBiometric({
    required String email,
    required String password,
  }) async {
    try {
      print('🔒 Starting biometric enable process...');
      print('🔒 Email: ${email.substring(0, 3)}...');

      // First authenticate with biometric
      print('🔒 Requesting biometric authentication...');
      final authenticated = await authenticate(
        reason: 'Enable fingerprint login',
      );

      print('🔒 Authentication result: $authenticated');

      if (!authenticated) {
        print('❌ Biometric authentication was cancelled or failed');
        return false;
      }

      // Store credentials securely
      print('🔒 Storing credentials securely...');
      await _secureStorage.write(key: _storedEmailKey, value: email);
      await _secureStorage.write(key: _storedPasswordKey, value: password);

      // Mark biometric as enabled
      print('🔒 Marking biometric as enabled...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnabledKey, true);

      print('✅ Biometric authentication enabled successfully');
      return true;
    } catch (e) {
      print('❌ Error enabling biometric: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Disable biometric authentication and clear stored credentials
  Future<bool> disableBiometric() async {
    try {
      // Clear stored credentials
      await _secureStorage.delete(key: _storedEmailKey);
      await _secureStorage.delete(key: _storedPasswordKey);

      // Mark biometric as disabled
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_biometricEnabledKey, false);

      print('✅ Biometric authentication disabled successfully');
      return true;
    } catch (e) {
      print('❌ Error disabling biometric: $e');
      return false;
    }
  }

  /// Authenticate user with biometric
  Future<bool> authenticate({required String reason}) async {
    try {
      print('🔒 Authenticate called with reason: $reason');

      // Check if biometric is supported
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      print('🔒 canCheckBiometrics: $canCheckBiometrics');
      print('🔒 isDeviceSupported: $isDeviceSupported');
      print('🔒 availableBiometrics: $availableBiometrics');

      if (!canCheckBiometrics) {
        print('❌ Cannot check biometrics on this device');
        return false;
      }

      if (availableBiometrics.isEmpty) {
        print(
          '❌ No biometrics enrolled. Please add fingerprint in Settings > Security > Fingerprint',
        );
        return false;
      }

      print('🔒 Device is ready, starting authentication...');
      print(
        '🔒 Available types: ${availableBiometrics.map((e) => e.name).join(", ")}',
      );

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly:
              false, // Allow PIN/pattern fallback for better compatibility
          useErrorDialogs: true,
          sensitiveTransaction: false,
        ),
      );

      print('🔒 Authentication result: $result');
      return result;
    } on PlatformException catch (e) {
      print('❌ Biometric PlatformException: ${e.code}');
      print('❌ Message: ${e.message}');
      print('❌ Details: ${e.details}');

      // Handle specific error codes
      switch (e.code) {
        case 'NotAvailable':
        case 'NotSupported':
          print('❌ Biometric authentication not available on this device');
          break;
        case 'NotEnrolled':
          print(
            '❌ No biometric enrolled. Go to Settings > Security > Fingerprint',
          );
          break;
        case 'LockedOut':
        case 'LockedOutPermanent':
        case 'PermanentlyLockedOut':
          print(
            '❌ Too many failed attempts. Wait 30 seconds or use device PIN',
          );
          break;
        case 'PasscodeNotSet':
          print('❌ Device PIN/pattern not set up');
          break;
        case 'AuthenticationCanceled':
        case 'UserCanceled':
          print('⚠️ User cancelled authentication');
          break;
        case 'AuthenticationFailed':
          print(
            '❌ Authentication failed - Wrong fingerprint or sensor misread',
          );
          break;
        case 'BiometricOnlyNotSupported':
          print('❌ This device requires PIN/pattern with biometric');
          break;
        default:
          print('❌ Error code: ${e.code}');
      }
      return false;
    } catch (e) {
      print('❌ Unexpected error during authentication: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Get stored credentials after successful biometric authentication
  Future<Map<String, String>?> getStoredCredentials() async {
    try {
      final email = await _secureStorage.read(key: _storedEmailKey);
      final password = await _secureStorage.read(key: _storedPasswordKey);

      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return null;
    } catch (e) {
      print('❌ Error retrieving stored credentials: $e');
      return null;
    }
  }

  /// Login with biometric authentication
  Future<Map<String, String>?> loginWithBiometric() async {
    try {
      // Check if biometric is enabled
      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        print('⚠️ Biometric login is not enabled');
        return null;
      }

      // Authenticate with biometric
      final authenticated = await authenticate(reason: 'Authenticate to login');

      if (!authenticated) {
        print('❌ Biometric authentication failed');
        return null;
      }

      // Get stored credentials
      final credentials = await getStoredCredentials();
      if (credentials == null) {
        print('❌ No stored credentials found');
        return null;
      }

      print('✅ Biometric login successful');
      return credentials;
    } catch (e) {
      print('❌ Error during biometric login: $e');
      return null;
    }
  }

  /// Test if biometric authentication works (for diagnostics)
  Future<bool> testBiometric() async {
    try {
      print('🔍 Testing biometric authentication...');
      return await authenticate(reason: 'Test your fingerprint sensor');
    } catch (e) {
      print('❌ Biometric test failed: $e');
      return false;
    }
  }

  /// Check if biometric has stored credentials
  Future<bool> hasStoredCredentials() async {
    try {
      final credentials = await getStoredCredentials();
      return credentials != null;
    } catch (e) {
      return false;
    }
  }
}
