import 'package:hive/hive.dart';
import '../constants/hive_table_constants.dart';
import '../../features/auth/data/models/auth_hive_model.dart';

class AuthHiveService {
  Box<AuthHiveModel> get _box =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authTable);

  String _key(String email) => email.toLowerCase().trim();

  AuthHiveModel _copy(AuthHiveModel user) {
    return AuthHiveModel(
      authId: user.authId,
      fullName: user.fullName,
      email: _key(user.email),
      phoneNumber: user.phoneNumber,
      password: user.password,
    );
  }

  /// ✅ SIGN UP (creates user and logs in)
  Future<String?> signup({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final key = _key(email);

      if (_box.containsKey(key)) {
        return "Email already registered";
      }

      final user = AuthHiveModel(
        authId: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName.trim(),
        email: key,
        phoneNumber: phoneNumber.trim(),
        password: password,
      );

      await _box.put(key, user);

      // ✅ store COPY as current user (avoid HiveObject double-key issue)
      await _box.put(HiveTableConstants.currentUserKey, _copy(user));

      return null;
    } catch (e) {
      return "Signup error: $e";
    }
  }

  /// ✅ LOGIN (sets current user)
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final key = _key(email);
      final user = _box.get(key);

      if (user == null) return "User not found. Please sign up first.";
      if (user.password != password) return "Incorrect password";

      await _box.put(HiveTableConstants.currentUserKey, _copy(user));
      return null;
    } catch (e) {
      return "Login error: $e";
    }
  }

  /// ✅ LOGOUT (removes current user)
  Future<void> logout() async {
    await _box.delete(HiveTableConstants.currentUserKey);
  }

  /// ✅ GET CURRENT USER
  AuthHiveModel? getCurrentUser() {
    return _box.get(HiveTableConstants.currentUserKey);
  }

  /// ✅ CHECK IF USER IS LOGGED IN (useful for splash)
  bool isLoggedIn() {
    return _box.containsKey(HiveTableConstants.currentUserKey);
  }
}
