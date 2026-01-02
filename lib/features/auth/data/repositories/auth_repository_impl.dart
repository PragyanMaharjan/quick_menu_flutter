import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/data/datasource/auth_datasource.dart';

import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';


import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, bool>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final userModel = AuthHiveModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: email.toLowerCase().trim(),
      phoneNumber: phoneNumber.trim(),
      password: password,
    );

    final error = await _dataSource.register(userModel);

    if (error != null) return Left(LocalFailure(error));

    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> login({
    required String email,
    required String password,
  }) async {
    final error = await _dataSource.login(email, password);

    if (error != null) return Left(LocalFailure(error));

    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _dataSource.logout();
      return const Right(true);
    } catch (e) {
      return Left(LocalFailure("Logout error: $e"));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    try {
      final user = _dataSource.getCurrentUser();
      if (user == null) return const Right(null);

      return Right(
        AuthEntity(
          userID: user.id,
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber,
        ),
      );
    } catch (e) {
      return Left(LocalFailure("Get user error: $e"));
    }
  }
}
