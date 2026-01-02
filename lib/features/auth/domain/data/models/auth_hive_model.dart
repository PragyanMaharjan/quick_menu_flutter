import 'package:hive/hive.dart';
import '../../../../../core/constants/hive_table_constants.dart';


part "auth_hive_model.g.dart";

@HiveType(typeId: HiveTableConstants.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String password;

  AuthHiveModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}
