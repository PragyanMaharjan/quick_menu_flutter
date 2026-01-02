class HiveTableConstants {
  HiveTableConstants._();

  /// Optional reference name (Hive doesn't use this directly)
  static const String dbName = 'quick_menu_db';

  /// ✅ Auth Hive Adapter typeId (must be unique across ALL adapters)
  static const int authTypeId = 0;

  /// ✅ Box name where auth users are stored
  static const String authBox = 'auth_box';

  /// ✅ Key used inside [authBox] to store the current logged in user
  /// NOTE: We store a COPY of the user model here to avoid HiveObject key conflict.
  static const String currentUserKey = 'current_user';

  /// (Optional) If you ever want to store token/session later
  static const String sessionKey = 'session';
}
