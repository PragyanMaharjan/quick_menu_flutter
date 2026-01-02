class HiveTableConstants {
  HiveTableConstants._();

  /// Hive database name (optional, mostly for reference)
  static const String dbName = 'quick_menu_db';

  /// Hive Type ID (must be unique in app)
  static const int authTypeId = 0;

  /// Hive Box name for auth
  static const String authBox = 'auth_box';

  /// Key for storing current logged-in user
  static const String currentUserKey = 'current_user';
}
