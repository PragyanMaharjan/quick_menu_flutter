import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/usecases/usecase.dart';
import 'package:quick_menu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable{

  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
  @override
  List<Object?> get props => [fullName, email, phoneNumber, password];
}

// provider for register usecase
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterParams> {

  final IAuthRepository _authRepository;
  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
    return _authRepository.register(entity);
  }
}