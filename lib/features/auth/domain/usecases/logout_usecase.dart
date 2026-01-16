import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/usecases/usecase.dart';
import 'package:quick_menu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';

typedef LogoutUsecase = UsecaseWithoutParms<bool>;

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LogoutUsecaseImpl(authRepository: authRepository);
});

class LogoutUsecaseImpl implements UsecaseWithoutParms<bool> {
  final IAuthRepository _authRepository;
  LogoutUsecaseImpl({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _authRepository.logout();
  }
}