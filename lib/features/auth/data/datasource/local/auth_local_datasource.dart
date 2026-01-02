import 'package:hive/hive.dart';
import 'package:quick_menu/core/constants/hive_table_constants.dart';
import 'package:quick_menu/features/auth/data/datasource/auth_datasource.dart';
import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';

class AuthLocalDataSource implements AuthDataSource {
  Box<AuthHiveModel> get _box =>
      Hive.box<AuthHiveModel>(HiveTableConstants.authBox);

  String _key(String email) => email.toLowerCase().trim();

  @override
  Future<String?> register(AuthHiveModel user) async {
    try {
      final key = _key(user.email);

      if (_box.containsKey(key)) {
        return "Email already registered";
      }

      await _box.put(key, user);
      await saveCurrentUser(user);

      return null;
    } catch (e) {
      return "Register error: $e";
    }
  }

  @override
  Future<String?> login(String email, String password) async {
    try {
      final key = _key(email);
      final user = _box.get(key);

      if (user == null) return "User not found. Please sign up first.";
      if (user.password != password) return "Incorrect password";

      await saveCurrentUser(user);
      return null;
    } catch (e) {
      return "Login error: $e";
    }
  }

  @override
  Future<void> saveCurrentUser(AuthHiveModel user) async {
    // ✅ store a COPY (prevents Hive same-object two-keys issue)
    final copy = AuthHiveModel(
      id: user.id,
      fullName: user.fullName,
      email: _key(user.email),
      phoneNumber: user.phoneNumber,
      password: user.password,
    );

    await _box.put(HiveTableConstants.currentUserKey, copy);
  }

  @override
  AuthHiveModel? getCurrentUser() {
    return _box.get(HiveTableConstants.currentUserKey);
  }

  @override
  Future<void> logout() async {
    await _box.delete(HiveTableConstants.currentUserKey);
  }
}
