import 'package:hive/hive.dart';
import 'package:quick_menu/core/constants/hive_table_constants.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.authTypeId)
class AuthHiveModel {
  @HiveField(0)
  final String authId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String password;

  const AuthHiveModel({
    required this.authId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userID: authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}
