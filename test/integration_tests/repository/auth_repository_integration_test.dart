import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockAuthLocalDataSource extends Mock {
  Future<UserData?> getCachedUser();
  Future<void> cacheUser(UserData user);
  Future<void> clearCache();
}

class MockAuthRemoteDataSource extends Mock {
  Future<UserData> login(String email, String password);
  Future<void> logout();
}

class UserData {
  final String id;
  final String email;
  UserData(this.id, this.email);
}

// Repository
class AuthRepository {
  final MockAuthLocalDataSource localDataSource;
  final MockAuthRemoteDataSource remoteDataSource;

  AuthRepository(this.localDataSource, this.remoteDataSource);

  Future<Either<Failure, UserData>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return const Left(ApiFailure(message: 'Login failed'));
    }
  }

  Future<Either<Failure, UserData?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return const Left(
        LocalDatabaseFailure(message: 'Failed to get cached user'),
      );
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return const Left(ApiFailure(message: 'Logout failed'));
    }
  }
}

void main() {
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepository repository;

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepository(mockLocalDataSource, mockRemoteDataSource);
  });

  setUpAll(() {
    registerFallbackValue(UserData('1', 'test@test.com'));
  });

  group('Auth Repository Integration Tests', () {
    final tUser = UserData('1', 'test@test.com');

    test('should login and cache user data', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.login('test@test.com', 'password'),
      ).thenAnswer((_) async => tUser);
      when(
        () => mockLocalDataSource.cacheUser(tUser),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.login('test@test.com', 'password');

      // Assert
      expect(result, Right(tUser));
      verify(
        () => mockRemoteDataSource.login('test@test.com', 'password'),
      ).called(1);
      verify(() => mockLocalDataSource.cacheUser(tUser)).called(1);
    });

    test('should get cached user when available', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedUser(),
      ).thenAnswer((_) async => tUser);

      // Act
      final result = await repository.getCachedUser();

      // Assert
      expect(result, Right(tUser));
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
    });

    test('should logout and clear cache', () async {
      // Arrange
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.clearCache()).thenAnswer((_) async => {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.logout()).called(1);
      verify(() => mockLocalDataSource.clearCache()).called(1);
    });
  });
}
