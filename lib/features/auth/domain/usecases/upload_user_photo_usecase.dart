import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/usecases/usecase.dart';
import 'package:quick_menu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';

class UploadUserPhotoParams extends Equatable {
  final String userId;
  final String photoPath;

  const UploadUserPhotoParams({required this.userId, required this.photoPath});

  @override
  List<Object?> get props => [userId, photoPath];
}

// Provider for upload user photo usecase
final uploadUserPhotoUsecaseProvider = Provider<UploadUserPhotoUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UploadUserPhotoUsecase(authRepository: authRepository);
});

class UploadUserPhotoUsecase
    implements UsecaseWithParms<AuthEntity, UploadUserPhotoParams> {
  final IAuthRepository _authRepository;

  UploadUserPhotoUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(UploadUserPhotoParams params) {
    return _authRepository.uploadUserPhoto(
      userId: params.userId,
      photoPath: params.photoPath,
    );
  }
}
