import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_menu/features/auth/domain/usecases/upload_user_photo_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late UploadUserPhotoUsecase uploadUserPhotoUsecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(fullName: 'Fallback User', email: 'fallback@test.com'),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    uploadUserPhotoUsecase = UploadUserPhotoUsecase(
      authRepository: mockAuthRepository,
    );
  });

  const tUserId = '123';
  const tPhotoPath = '/storage/emulated/0/DCIM/photo.jpg';

  final tAuthEntity = AuthEntity(
    userID: tUserId,
    fullName: 'John Doe',
    email: 'john@test.com',
    phoneNumber: '1234567890',
    photoUrl: 'https://api.example.com/photos/123/photo.jpg',
  );

  group('UploadUserPhotoUsecase', () {
    test(
      'should return updated AuthEntity when photo upload is successful',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.uploadUserPhoto(
            userId: tUserId,
            photoPath: tPhotoPath,
          ),
        ).thenAnswer((_) async => Right(tAuthEntity));

        // Act
        final result = await uploadUserPhotoUsecase(
          const UploadUserPhotoParams(userId: tUserId, photoPath: tPhotoPath),
        );

        // Assert
        expect(result, Right(tAuthEntity));
        verify(
          () => mockAuthRepository.uploadUserPhoto(
            userId: tUserId,
            photoPath: tPhotoPath,
          ),
        ).called(1);
      },
    );

    test('should return ApiFailure when file is too large', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'File size exceeds maximum limit of 5MB',
        statusCode: 413,
      );
      when(
        () => mockAuthRepository.uploadUserPhoto(
          userId: tUserId,
          photoPath: tPhotoPath,
        ),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await uploadUserPhotoUsecase(
        const UploadUserPhotoParams(userId: tUserId, photoPath: tPhotoPath),
      );

      // Assert
      expect(result, Left(tFailure));
      expect(
        result.fold((l) => l.message, (r) => ''),
        'File size exceeds maximum limit of 5MB',
      );
    });

    test('should return APIFailure when file format is unsupported', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Unsupported file format. Only JPG and PNG are allowed',
        statusCode: 400,
      );
      when(
        () => mockAuthRepository.uploadUserPhoto(
          userId: tUserId,
          photoPath: '/path/to/photo.gif',
        ),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await uploadUserPhotoUsecase(
        const UploadUserPhotoParams(
          userId: tUserId,
          photoPath: '/path/to/photo.gif',
        ),
      );

      // Assert
      expect(result, Left(tFailure));
    });

    test('should return ApiFailure when server error occurs', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Failed to upload photo to server',
        statusCode: 500,
      );
      when(
        () => mockAuthRepository.uploadUserPhoto(
          userId: tUserId,
          photoPath: tPhotoPath,
        ),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await uploadUserPhotoUsecase(
        const UploadUserPhotoParams(userId: tUserId, photoPath: tPhotoPath),
      );

      // Assert
      expect(result, Left(tFailure));
    });

    test('should pass correct parameters to repository', () async {
      // Arrange
      when(
        () => mockAuthRepository.uploadUserPhoto(
          userId: tUserId,
          photoPath: tPhotoPath,
        ),
      ).thenAnswer((_) async => Right(tAuthEntity));

      // Act
      await uploadUserPhotoUsecase(
        const UploadUserPhotoParams(userId: tUserId, photoPath: tPhotoPath),
      );

      // Assert
      verify(
        () => mockAuthRepository.uploadUserPhoto(
          userId: tUserId,
          photoPath: tPhotoPath,
        ),
      ).called(1);
    });
  });

  group('UploadUserPhotoParams', () {
    test('should be equal when all properties are the same', () {
      const params1 = UploadUserPhotoParams(
        userId: tUserId,
        photoPath: tPhotoPath,
      );
      const params2 = UploadUserPhotoParams(
        userId: tUserId,
        photoPath: tPhotoPath,
      );

      expect(params1, params2);
    });

    test('should have all props in the props list', () {
      const params = UploadUserPhotoParams(
        userId: tUserId,
        photoPath: tPhotoPath,
      );

      expect(params.props, [tUserId, tPhotoPath]);
    });
  });
}
