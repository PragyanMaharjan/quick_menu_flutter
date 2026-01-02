import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, bool>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, AuthEntity?>> getCurrentUser();
}
