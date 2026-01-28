import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/services/connecitivity/network_info.dart';
import 'package:quick_menu/features/auth/data/datasource/auth_datasource.dart';
import 'package:quick_menu/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:quick_menu/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:quick_menu/features/auth/data/models/auth_api_model.dart';
import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';

//provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);

  final authRemoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authDataSource.getCurrentUser();
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: "Invalid email or password"));
      } on DioException catch (e) {
        print('❌ [REPO] DioException during upload: ${e.message}');
        print('❌ [REPO] Status code: ${e.response?.statusCode}');
        print('❌ [REPO] Response data: ${e.response?.data}');

        String errorMessage = 'Photo upload failed: ${e.message}';
        if (e.response?.data is Map<String, dynamic>) {
          final responseData = e.response!.data as Map<String, dynamic>;
          errorMessage = responseData['message'] ?? errorMessage;
        } else if (e.response?.data is String) {
          errorMessage = e.response!.data.toString();
        }

        return Left(
          ApiFailure(message: errorMessage, statusCode: e.response?.statusCode),
        );
      } catch (e) {
        print('❌ [REPO] General exception: ${e.toString()}');
        return Left(ApiFailure(message: 'Photo upload error: ${e.toString()}'));
      }
    } else {
      try {
        final model = await _authDataSource.login(email, password);
        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }
        return const Left(
          LocalDatabaseFailure(message: "Invalid email or password"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data?['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Check if email already exists
        final existingUser = await _authDataSource.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }
        final authModel = AuthHiveModel(
          authId:
              user.userID ?? DateTime.now().millisecondsSinceEpoch.toString(),
          fullName: user.fullName,
          email: user.email,
          phoneNumber: user.phoneNumber ?? '',
          password: user.password ?? '',
        );
        await _authDataSource.register(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> uploadUserPhoto({
    required String userId,
    required String photoPath,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.uploadUserPhoto(
          userId,
          photoPath,
        );
        final entity = apiModel.toEntity();
        return Right(entity);
      } on DioException catch (e) {
        String errorMessage = 'Photo upload failed';
        if (e.response?.data is Map<String, dynamic>) {
          final responseData = e.response!.data as Map<String, dynamic>;
          errorMessage = responseData['message'] ?? errorMessage;
        } else if (e.response?.data is String) {
          errorMessage = e.response!.data.toString();
        }

        if (e.message != null) {
          errorMessage = '$errorMessage (${e.message})';
        }

        if (e.response?.statusCode == 400) {
          errorMessage = 'Bad request - Check field names match backend';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Unauthorized - Token expired or invalid';
        } else if (e.response?.statusCode == 413) {
          errorMessage = 'File too large - Reduce image size';
        } else if (e.response?.statusCode == 500) {
          errorMessage = 'Server error - Check backend logs';
        }

        return Left(
          ApiFailure(message: errorMessage, statusCode: e.response?.statusCode),
        );
      } catch (e) {
        print('❌ General exception in uploadUserPhoto: $e');
        return Left(ApiFailure(message: 'Upload error: ${e.toString()}'));
      }
    } else {
      return const Left(ApiFailure(message: "No internet connection"));
    }
  }
}
