import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock user profile entity
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });
}

// Mock failure class
abstract class Failure {}

class ServerFailure extends Failure {}

class NoInternetFailure extends Failure {}

// Mock repository
class MockProfileRepository extends Mock {
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    return Right(
      UserProfile(
        id: '123',
        name: 'John Doe',
        email: 'john@test.com',
        photoUrl: 'https://example.com/photo.jpg',
      ),
    );
  }

  Future<Either<Failure, void>> updateUserProfile(UserProfile profile) async {
    return Right(null);
  }
}

// Usecases for profile
class GetUserProfileUsecase {
  final MockProfileRepository repository;

  GetUserProfileUsecase(this.repository);

  Future<Either<Failure, UserProfile>> call() async {
    return repository.getUserProfile();
  }
}

class UpdateUserProfileUsecase {
  final MockProfileRepository repository;

  UpdateUserProfileUsecase(this.repository);

  Future<Either<Failure, void>> call(UserProfile profile) async {
    return repository.updateUserProfile(profile);
  }
}

void main() {
  late GetUserProfileUsecase getUserProfileUsecase;
  late UpdateUserProfileUsecase updateUserProfileUsecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    getUserProfileUsecase = GetUserProfileUsecase(mockProfileRepository);
    updateUserProfileUsecase = UpdateUserProfileUsecase(mockProfileRepository);

    // Register fallback value for UserProfile
    registerFallbackValue(
      UserProfile(
        id: '0',
        name: 'Fallback',
        email: 'fallback@test.com',
        photoUrl: 'fallback.jpg',
      ),
    );
  });

  group('GetUserProfileUsecase', () {
    test('should return user profile when successful', () async {
      // Act
      final result = await getUserProfileUsecase();

      // Assert
      expect(result, isA<Right<Failure, UserProfile>>());
      result.fold((failure) => fail('Should return right'), (profile) {
        expect(profile.name, 'John Doe');
        expect(profile.email, 'john@test.com');
      });
    });

    test('should include correct user id in profile', () async {
      // Act
      final result = await getUserProfileUsecase();

      // Assert
      result.fold((failure) => fail('Should return right'), (profile) {
        expect(profile.id, '123');
        expect(profile.photoUrl, 'https://example.com/photo.jpg');
      });
    });

    test('should have valid user properties', () async {
      // Act
      final result = await getUserProfileUsecase();

      // Assert
      expect(result, isA<Right<Failure, UserProfile>>());
    });
  });

  group('UpdateUserProfileUsecase', () {
    test('should update user profile successfully', () async {
      // Arrange
      final updatedProfile = UserProfile(
        id: '123',
        name: 'Jane Doe',
        email: 'jane@test.com',
        photoUrl: 'https://example.com/new-photo.jpg',
      );

      // Act
      final result = await updateUserProfileUsecase(updatedProfile);

      // Assert
      expect(result, isA<Right<Failure, void>>());
    });

    test('should handle profile updates without error', () async {
      // Arrange
      final profile = UserProfile(
        id: '123',
        name: 'Test',
        email: 'test@test.com',
        photoUrl: 'url',
      );

      // Act
      final result = await updateUserProfileUsecase(profile);

      // Assert
      expect(result, isA<Right<Failure, void>>());
    });
  });
}
