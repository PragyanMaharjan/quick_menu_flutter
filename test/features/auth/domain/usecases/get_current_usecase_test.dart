import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_menu/features/auth/domain/usecases/get_current_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCurrentUserUsecase getCurrentUserUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    getCurrentUserUsecase = GetCurrentUserUsecase(
      authRepository: mockAuthRepository,
    );
  });

  const tAuthEntity = AuthEntity(
    userID: '123',
    fullName: 'John Doe',
    email: 'john@test.com',
    phoneNumber: '1234567890',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('GetCurrentUserUsecase', () {
    test('should return AuthEntity when user is logged in', () async {
      // Arrange
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when no token is stored', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'No authentication token found',
        statusCode: 401,
      );
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result, Left(tFailure));
      expect(
        result.fold((l) => l.message, (r) => ''),
        'No authentication token found',
      );
    });

    test('should return Failure when token is expired', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Token expired',
        statusCode: 401,
      );
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result, Left(tFailure));
    });

    test('should return ApiFailure when server error occurs', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Failed to fetch user data',
        statusCode: 500,
      );
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.getCurrentUser()).called(1);
    });

    test('should correctly map API response to AuthEntity', () async {
      // Arrange
      final expectedUser = AuthEntity(
        userID: '456',
        fullName: 'Jane Smith',
        email: 'jane@test.com',
        phoneNumber: '9876543210',
        photoUrl: 'https://example.com/jane.jpg',
      );
      when(
        () => mockAuthRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right(expectedUser));

      // Act
      final result = await getCurrentUserUsecase();

      // Assert
      expect(result, Right(expectedUser));
      result.fold((failure) => fail('Should not fail'), (user) {
        expect(user.userID, '456');
        expect(user.fullName, 'Jane Smith');
        expect(user.email, 'jane@test.com');
      });
    });
  });
}
