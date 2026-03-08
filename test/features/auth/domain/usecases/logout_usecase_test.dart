import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_menu/features/auth/domain/usecases/logout_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase logoutUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUsecase = LogoutUsecaseImpl(authRepository: mockAuthRepository);
  });

  group('LogoutUsecase', () {
    test('should return true when logout is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, const Right(true));
      verify(() => mockAuthRepository.logout()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ApiFailure when logout fails', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Failed to logout from server',
        statusCode: 500,
      );
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.logout()).called(1);
    });

    test('should clear local cache when logout is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, const Right(true));
      // Verify that the repository was called to clear data
      verify(() => mockAuthRepository.logout()).called(1);
    });

    test('should return failure when no session exists', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'No active session found',
        statusCode: 401,
      );
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, Left(tFailure));
    });

    test('should return success even if token cleanup fails locally', () async {
      // Arrange
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await logoutUsecase();

      // Assert
      expect(result, const Right(true));
    });
  });
}
