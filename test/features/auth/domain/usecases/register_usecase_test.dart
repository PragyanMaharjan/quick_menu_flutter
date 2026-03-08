import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/repositories/auth_repository.dart';
import 'package:quick_menu/features/auth/domain/usecases/register_usecase.dart';

// Mock repository
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase registerUsecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(fullName: 'Fallback User', email: 'fallback@test.com'),
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUsecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  const tFullName = 'John Doe';
  const tEmail = 'john@test.com';
  const tPhoneNumber = '1234567890';
  const tPassword = 'securePassword123';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await registerUsecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          phoneNumber: tPhoneNumber,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockAuthRepository.register(any())).called(1);
    });

    test(
      'should return ApiFailure when registration fails with invalid email',
      () async {
        // Arrange
        final tFailure = const ApiFailure(
          message: 'Invalid email format',
          statusCode: 400,
        );
        when(
          () => mockAuthRepository.register(any()),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        final result = await registerUsecase(
          const RegisterParams(
            fullName: tFullName,
            email: 'invalid-email',
            phoneNumber: tPhoneNumber,
            password: tPassword,
          ),
        );

        // Assert
        expect(result, Left(tFailure));
      },
    );

    test('should return ApiFailure when email already exists', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Email already registered',
        statusCode: 409,
      );
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await registerUsecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          phoneNumber: tPhoneNumber,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, Left(tFailure));
      expect(
        result.fold((l) => l.message, (r) => ''),
        'Email already registered',
      );
    });

    test('should return ApiFailure when server error occurs', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Server error occurred',
        statusCode: 500,
      );
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await registerUsecase(
        const RegisterParams(
          fullName: tFullName,
          email: tEmail,
          phoneNumber: tPhoneNumber,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, Left(tFailure));
    });
  });

  group('RegisterParams', () {
    test('should be equal when all properties are the same', () {
      const params1 = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        phoneNumber: tPhoneNumber,
        password: tPassword,
      );
      const params2 = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        phoneNumber: tPhoneNumber,
        password: tPassword,
      );

      expect(params1, params2);
    });

    test('should have all props in the props list', () {
      const params = RegisterParams(
        fullName: tFullName,
        email: tEmail,
        phoneNumber: tPhoneNumber,
        password: tPassword,
      );

      expect(params.props, [tFullName, tEmail, tPhoneNumber, tPassword]);
    });
  });
}
