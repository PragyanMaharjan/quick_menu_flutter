import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockAuthRepository extends Mock {
  Future<Either<Failure, AuthData>> login(String email, String password);
  Future<Either<Failure, bool>> register(RegisterData data);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthData>> getCurrentUser();
  Future<Either<Failure, AuthData>> uploadUserPhoto(
    String userId,
    String photoPath,
  );
}

class AuthData {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  AuthData(this.id, this.email, this.name, this.photoUrl);
}

class RegisterData {
  final String email;
  final String password;
  final String name;
  RegisterData(this.email, this.password, this.name);
}

// Use Cases
class LoginUseCase {
  final MockAuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, AuthData>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}

class RegisterUseCase {
  final MockAuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, bool>> call(RegisterData data) async {
    return await repository.register(data);
  }
}

class LogoutUseCase {
  final MockAuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}

class GetCurrentUserUseCase {
  final MockAuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, AuthData>> call() async {
    return await repository.getCurrentUser();
  }
}

class UploadUserPhotoUseCase {
  final MockAuthRepository repository;
  UploadUserPhotoUseCase(this.repository);

  Future<Either<Failure, AuthData>> call(
    String userId,
    String photoPath,
  ) async {
    return await repository.uploadUserPhoto(userId, photoPath);
  }
}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;
  late LogoutUseCase logoutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late UploadUserPhotoUseCase uploadUserPhotoUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
    registerUseCase = RegisterUseCase(mockRepository);
    logoutUseCase = LogoutUseCase(mockRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(mockRepository);
    uploadUserPhotoUseCase = UploadUserPhotoUseCase(mockRepository);
  });

  group('Login UseCase Tests', () {
    final tAuthData = AuthData('1', 'test@test.com', 'Test User', null);

    test('should login user successfully', () async {
      // Arrange
      when(
        () => mockRepository.login('test@test.com', 'password123'),
      ).thenAnswer((_) async => Right(tAuthData));

      // Act
      final result = await loginUseCase('test@test.com', 'password123');

      // Assert
      expect(result, Right(tAuthData));
      verify(
        () => mockRepository.login('test@test.com', 'password123'),
      ).called(1);
    });

    test('should return failure when login fails', () async {
      // Arrange
      when(() => mockRepository.login('wrong@test.com', 'wrong')).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Invalid credentials')),
      );

      // Act
      final result = await loginUseCase('wrong@test.com', 'wrong');

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.login('wrong@test.com', 'wrong')).called(1);
    });
  });

  group('Register UseCase Tests', () {
    final tRegisterData = RegisterData(
      'new@test.com',
      'password123',
      'New User',
    );

    test('should register user successfully', () async {
      // Arrange
      when(
        () => mockRepository.register(tRegisterData),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await registerUseCase(tRegisterData);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(tRegisterData)).called(1);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      when(() => mockRepository.register(tRegisterData)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Email already exists')),
      );

      // Act
      final result = await registerUseCase(tRegisterData);

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.register(tRegisterData)).called(1);
    });
  });

  group('Logout UseCase Tests', () {
    test('should logout user successfully', () async {
      // Arrange
      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.logout()).called(1);
    });

    test('should return failure when logout fails', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Logout failed')),
      );

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.logout()).called(1);
    });
  });

  group('Get Current User UseCase Tests', () {
    final tAuthData = AuthData('1', 'test@test.com', 'Test User', 'photo.jpg');

    test('should get current user successfully', () async {
      // Arrange
      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right(tAuthData));

      // Act
      final result = await getCurrentUserUseCase();

      // Assert
      expect(result, Right(tAuthData));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return failure when no user is logged in', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenAnswer(
        (_) async =>
            const Left(LocalDatabaseFailure(message: 'No user logged in')),
      );

      // Act
      final result = await getCurrentUserUseCase();

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.getCurrentUser()).called(1);
    });
  });

  group('Upload User Photo UseCase Tests', () {
    final tAuthData = AuthData(
      '1',
      'test@test.com',
      'Test User',
      'new_photo.jpg',
    );

    test('should upload user photo successfully', () async {
      // Arrange
      when(
        () => mockRepository.uploadUserPhoto('1', '/path/to/photo.jpg'),
      ).thenAnswer((_) async => Right(tAuthData));

      // Act
      final result = await uploadUserPhotoUseCase('1', '/path/to/photo.jpg');

      // Assert
      expect(result, Right(tAuthData));
      verify(
        () => mockRepository.uploadUserPhoto('1', '/path/to/photo.jpg'),
      ).called(1);
    });

    test('should return failure when photo upload fails', () async {
      // Arrange
      when(
        () => mockRepository.uploadUserPhoto('1', '/path/to/photo.jpg'),
      ).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Upload failed')),
      );

      // Act
      final result = await uploadUserPhotoUseCase('1', '/path/to/photo.jpg');

      // Assert
      expect(result.isLeft(), true);
      verify(
        () => mockRepository.uploadUserPhoto('1', '/path/to/photo.jpg'),
      ).called(1);
    });
  });
}
