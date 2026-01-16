import 'package:dartz/dartz.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/usecases/usecase.dart';
import 'package:quick_menu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';

// Create Provider
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUsecase(authRepository: authRepository);
});

class GetCurrentUserUsecase implements UsecaseWithoutParms<AuthEntity> {
  final IAuthRepository _authRepository;

  GetCurrentUserUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _authRepository.getCurrentUser();
  }
}