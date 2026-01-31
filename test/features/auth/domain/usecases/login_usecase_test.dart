import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_menu/features/auth/domain/usecases/login_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  const tEmail = 'test@gmail.com';
  const tPassword = 'password123';

  const tAuthEntity = AuthEntity(
    userID: '123',
    fullName: 'John Doe',
    email: 'test@gmail.com',
    phoneNumber: '9876543210',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('LoginUsecase', () {
    test(
      'should get AuthEntity from repository when login is successful',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.login(tEmail, tPassword),
        ).thenAnswer((_) async => Right(tAuthEntity));

        // Act
        final result = await loginUsecase(
          LoginParams(email: tEmail, password: tPassword),
        );

        // Assert
        expect(result, Right(tAuthEntity));
        verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should return ApiFailure when login fails', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Invalid credentials',
        statusCode: 401,
      );
      when(
        () => mockAuthRepository.login(tEmail, tPassword),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await loginUsecase(
        LoginParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    });

    test('should return failure when repository throws exception', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(tEmail, tPassword),
      ).thenThrow(Exception('Connection error'));

      // Act & Assert
      expect(
        () => loginUsecase(LoginParams(email: tEmail, password: tPassword)),
        throwsException,
      );
    });

    test('should call repository with correct parameters', () async {
      // Arrange
      when(
        () => mockAuthRepository.login(tEmail, tPassword),
      ).thenAnswer((_) async => Right(tAuthEntity));

      // Act
      await loginUsecase(LoginParams(email: tEmail, password: tPassword));

      // Assert
      verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    });
  });

  group('LoginParams', () {
    test('should support equality', () {
      // Arrange
      final params1 = LoginParams(email: tEmail, password: tPassword);
      final params2 = LoginParams(email: tEmail, password: tPassword);

      // Assert
      expect(params1, equals(params2));
    });

    test('should support props comparison', () {
      // Arrange
      final params = LoginParams(email: tEmail, password: tPassword);

      // Assert
      expect(params.props, [tEmail, tPassword]);
    });
  });
}
