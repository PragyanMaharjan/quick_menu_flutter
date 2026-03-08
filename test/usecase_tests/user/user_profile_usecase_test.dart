import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockUserRepository extends Mock {
  Future<Either<Failure, User>> getUserProfile(String userId);
  Future<Either<Failure, User>> updateUserProfile(User user);
  Future<Either<Failure, void>> deleteUserAccount(String userId);
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class GetUserProfileUseCase {
  final MockUserRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}

class UpdateUserProfileUseCase {
  final MockUserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, User>> call(User user) {
    return repository.updateUserProfile(user);
  }
}

class DeleteUserAccountUseCase {
  final MockUserRepository repository;

  DeleteUserAccountUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.deleteUserAccount(userId);
  }
}

void main() {
  late MockUserRepository mockRepository;
  late GetUserProfileUseCase getUserProfileUseCase;
  late UpdateUserProfileUseCase updateUserProfileUseCase;
  late DeleteUserAccountUseCase deleteUserAccountUseCase;

  setUp(() {
    mockRepository = MockUserRepository();
    getUserProfileUseCase = GetUserProfileUseCase(mockRepository);
    updateUserProfileUseCase = UpdateUserProfileUseCase(mockRepository);
    deleteUserAccountUseCase = DeleteUserAccountUseCase(mockRepository);
  });

  group('Get User Profile UseCase Tests', () {
    final tUser = User(id: '1', name: 'John', email: 'john@test.com');

    test('should get user profile from repository', () async {
      // Arrange
      when(
        () => mockRepository.getUserProfile('1'),
      ).thenAnswer((_) async => Right(tUser));

      // Act
      final result = await getUserProfileUseCase('1');

      // Assert
      expect(result, Right(tUser));
      verify(() => mockRepository.getUserProfile('1')).called(1);
    });

    test('should return failure when user not found', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'User not found', statusCode: 404);
      when(
        () => mockRepository.getUserProfile('999'),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await getUserProfileUseCase('999');

      // Assert
      expect(result, const Left(tFailure));
    });
  });

  group('Update User Profile UseCase Tests', () {
    final tUser = User(id: '1', name: 'John Updated', email: 'john@test.com');

    test('should update user profile successfully', () async {
      // Arrange
      when(
        () => mockRepository.updateUserProfile(tUser),
      ).thenAnswer((_) async => Right(tUser));

      // Act
      final result = await updateUserProfileUseCase(tUser);

      // Assert
      expect(result, Right(tUser));
      verify(() => mockRepository.updateUserProfile(tUser)).called(1);
    });
  });

  group('Delete User Account UseCase Tests', () {
    test('should delete user account successfully', () async {
      // Arrange
      when(
        () => mockRepository.deleteUserAccount('1'),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await deleteUserAccountUseCase('1');

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.deleteUserAccount('1')).called(1);
    });
  });
}
