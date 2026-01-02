import '../models/auth_hive_model.dart';

/// DataSource = low-level data operations (Hive/local storage)
/// Repository will use this and convert Model <-> Entity.
/// UI should NEVER call this directly.
abstract class AuthDataSource {
  /// Create user (Sign Up)
  Future<String?> register(AuthHiveModel user);

  /// Verify user (Login)
  Future<String?> login(String email, String password);

  /// Save current logged-in user (store copy)
  Future<void> saveCurrentUser(AuthHiveModel user);

  /// Get current logged-in user (if any)
  AuthHiveModel? getCurrentUser();

  /// Remove current user (Logout)
  Future<void> logout();
}
