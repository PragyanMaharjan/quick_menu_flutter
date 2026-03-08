import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockProfileLocalDataSource extends Mock {
  Future<ProfileData?> getCachedProfile();
  Future<void> cacheProfile(ProfileData profile);
}

class MockProfileRemoteDataSource extends Mock {
  Future<ProfileData> getProfile(String userId);
  Future<void> updateProfile(ProfileData profile);
}

class ProfileData {
  final String id;
  final String name;
  final String email;
  final String? phone;
  ProfileData(this.id, this.name, this.email, this.phone);
}

// Repository
class ProfileRepository {
  final MockProfileLocalDataSource localDataSource;
  final MockProfileRemoteDataSource remoteDataSource;

  ProfileRepository(this.localDataSource, this.remoteDataSource);

  Future<Either<Failure, ProfileData>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      await localDataSource.cacheProfile(profile);
      return Right(profile);
    } catch (e) {
      try {
        final cachedProfile = await localDataSource.getCachedProfile();
        if (cachedProfile != null) {
          return Right(cachedProfile);
        }
        return const Left(LocalDatabaseFailure(message: 'No profile found'));
      } catch (cacheError) {
        return const Left(ApiFailure(message: 'Failed to get profile'));
      }
    }
  }

  Future<Either<Failure, void>> updateProfile(ProfileData profile) async {
    try {
      await remoteDataSource.updateProfile(profile);
      await localDataSource.cacheProfile(profile);
      return const Right(null);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to update profile'));
    }
  }
}

void main() {
  late MockProfileLocalDataSource mockLocalDataSource;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late ProfileRepository repository;

  setUp(() {
    mockLocalDataSource = MockProfileLocalDataSource();
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepository(mockLocalDataSource, mockRemoteDataSource);
  });

  setUpAll(() {
    registerFallbackValue(ProfileData('1', 'Test', 'test@test.com', null));
  });

  group('Profile Repository Integration Tests', () {
    final tProfile = ProfileData(
      '1',
      'John Doe',
      'john@test.com',
      '1234567890',
    );

    test('should get profile from remote and cache it', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getProfile('1'),
      ).thenAnswer((_) async => tProfile);
      when(
        () => mockLocalDataSource.cacheProfile(tProfile),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getProfile('1');

      // Assert
      expect(result, Right(tProfile));
      verify(() => mockRemoteDataSource.getProfile('1')).called(1);
      verify(() => mockLocalDataSource.cacheProfile(tProfile)).called(1);
    });

    test('should fallback to cached profile when remote fails', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getProfile('1'),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockLocalDataSource.getCachedProfile(),
      ).thenAnswer((_) async => tProfile);

      // Act
      final result = await repository.getProfile('1');

      // Assert
      expect(result, Right(tProfile));
      verify(() => mockLocalDataSource.getCachedProfile()).called(1);
    });

    test('should update profile on remote and cache', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.updateProfile(tProfile),
      ).thenAnswer((_) async => {});
      when(
        () => mockLocalDataSource.cacheProfile(tProfile),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.updateProfile(tProfile);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.updateProfile(tProfile)).called(1);
      verify(() => mockLocalDataSource.cacheProfile(tProfile)).called(1);
    });
  });
}
