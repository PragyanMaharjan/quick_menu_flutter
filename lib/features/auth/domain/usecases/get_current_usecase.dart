import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Returns the currently logged-in user (if any)
class GetCurrentUserUseCase implements UseCase<AuthEntity?> {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity?>> call() {
    return repository.getCurrentUser();
  }
}
