import 'package:hive/hive.dart';
import '../constants/hive_table_constants.dart';
import '../../features/auth/domain/data/models/auth_hive_model.dart';

class AuthHiveService {
  Box<AuthHiveModel> get _box =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authBox);

  /// SIGN UP
  Future<String?> signup({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final key = email.toLowerCase().trim();

      if (_box.containsKey(key)) {
        return "Email already registered";
      }

      final user = AuthHiveModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName.trim(),
        email: key,
        phoneNumber: phoneNumber.trim(),
        password: password,
      );

      // ✅ Store user ONLY ONCE
      await _box.put(key, user);

      // ✅ Store ONLY the key for current user
      await _box.put(
        HiveTableConstants.currentUserKey,
        AuthHiveModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          password: user.password,
        ),
      );

      return null;
    } catch (e) {
      return "Signup error: $e";
    }
  }

  /// LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final key = email.toLowerCase().trim();
      final user = _box.get(key);

      if (user == null) return "User not found. Please sign up first.";
      if (user.password != password) return "Incorrect password";

      // ✅ Save a COPY as current user
      await _box.put(
        HiveTableConstants.currentUserKey,
        AuthHiveModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          password: user.password,
        ),
      );

      return null;
    } catch (e) {
      return "Login error: $e";
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _box.delete(HiveTableConstants.currentUserKey);
  }

  /// GET CURRENT USER
  AuthHiveModel? getCurrentUser() {
    return _box.get(HiveTableConstants.currentUserKey);
  }
}
