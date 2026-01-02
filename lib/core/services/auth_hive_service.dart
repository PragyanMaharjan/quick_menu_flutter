import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
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
    final key = email.toLowerCase().trim();

    if (_box.get(key) != null) {
      return "Email already registered";
    }

    final user = AuthHiveModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: key,
      phoneNumber: phoneNumber,
      password: password,
    );

    await _box.put(key, user);
    await _box.put(HiveTableConstants.currentUserKey, user);

    return null;
  }

  /// LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final key = email.toLowerCase().trim();
    final user = _box.get(key);

    if (user == null) return "User not found";
    if (user.password != password) return "Incorrect password";

    await _box.put(HiveTableConstants.currentUserKey, user);
    return null;
  }
}
