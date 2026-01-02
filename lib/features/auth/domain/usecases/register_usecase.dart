import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
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

class RegisterUseCase
    implements UseCaseWithParams<bool, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    return repository.register(
      fullName: params.fullName.trim(),
      email: params.email.trim(),
      phoneNumber: params.phoneNumber.trim(),
      password: params.password,
    );
  }
}
