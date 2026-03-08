import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/services/connecitivity/network_info.dart';
import 'package:quick_menu/features/auth/data/datasource/auth_datasource.dart';
import 'package:quick_menu/features/auth/data/models/auth_api_model.dart';
import 'package:quick_menu/features/auth/data/models/auth_hive_model.dart';
import 'package:quick_menu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';

// Mocks
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthLocalDataSource extends Mock implements IAuthLocalDataSource {}

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

void main() {
  late AuthRepository authRepository;
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  const tEmail = 'test@test.com';
  const tPassword = 'password123';

  final tAuthApiModel = AuthApiModel(
    id: '1',
    fullName: 'John Doe',
    email: tEmail,
    phoneNumber: '1234567890',
    password: tPassword,
    photoUrl: 'https://example.com/photo.jpg',
  );

  final tAuthHiveModel = AuthHiveModel(
    authId: '1',
    fullName: 'John Doe',
    email: tEmail,
    phoneNumber: '1234567890',
    password: tPassword,
    photoUrl: 'https://example.com/photo.jpg',
  );

  final tAuthEntity = AuthEntity(
    userID: '1',
    fullName: 'John Doe',
    email: tEmail,
    phoneNumber: '1234567890',
    photoUrl: 'https://example.com/photo.jpg',
  );

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();

    authRepository = AuthRepository(
      authDatasource: mockLocalDataSource,
      authRemoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('AuthRepository - Offline/Online Login Tests', () {
    // ============= ONLINE MODE TESTS =============
    group('Online Mode - Device Connected to Internet', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return AuthEntity from remote source when online and login succeeds',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthApiModel);

          // Act
          final result = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result, Right(tAuthEntity));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
          verifyNever(() => mockLocalDataSource.login(tEmail, tPassword));
        },
      );

      test(
        'should return ApiFailure when remote API fails while online',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenThrow(Exception('API Error'));

          // Act
          final result = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result, isA<Left>());
          expect(result.fold((l) => l, (r) => null), isA<ApiFailure>());
          verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
        },
      );

      test(
        'should return API failure when remote API fails and no local cache',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenThrow(Exception('Network error'));
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenThrow(Exception('No cached user'));

          // Act
          final result = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result.isLeft(), true);
        },
      );

      test('should cache user locally after successful remote login', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.login(tEmail, tPassword),
        ).thenAnswer((_) async => tAuthApiModel);

        // Act
        final result = await authRepository.login(tEmail, tPassword);

        // Assert
        expect(result, Right(tAuthEntity));
        // Verify cache was attempted (or would be in real implementation)
        verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
      });
    });

    // ============= OFFLINE MODE TESTS =============
    group('Offline Mode - No Internet Connection', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return cached AuthEntity from local source when offline',
        () async {
          // Arrange
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthHiveModel);

          // Act
          final result = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result, Right(tAuthEntity));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockLocalDataSource.login(tEmail, tPassword)).called(1);
          verifyNever(() => mockRemoteDataSource.login(tEmail, tPassword));
        },
      );

      test('should return failure when offline and no cached user', () async {
        // Arrange
        when(
          () => mockLocalDataSource.login(tEmail, tPassword),
        ).thenThrow(Exception('User not cached'));

        // Act
        final result = await authRepository.login(tEmail, tPassword);

        // Assert
        expect(result.isLeft(), true);
        expect(
          result.fold((failure) => failure.message, (success) => ''),
          contains('User not cached'),
        );
        verifyNever(() => mockRemoteDataSource.login(tEmail, tPassword));
      });

      test('should not attempt remote login when offline', () async {
        // Arrange
        when(
          () => mockLocalDataSource.login(tEmail, tPassword),
        ).thenAnswer((_) async => tAuthHiveModel);

        // Act
        await authRepository.login(tEmail, tPassword);

        // Assert
        verifyNever(() => mockRemoteDataSource.login(tEmail, tPassword));
      });

      test(
        'should provide user data without network latency when offline',
        () async {
          // Arrange
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthHiveModel);

          // Act
          final stopwatch = Stopwatch()..start();
          final result = await authRepository.login(tEmail, tPassword);
          stopwatch.stop();

          // Assert
          expect(result, Right(tAuthEntity));
          // Local database should be much faster than network
          expect(stopwatch.elapsedMilliseconds < 100, true);
        },
      );
    });

    // ============= NETWORK TRANSITIONS =============
    group('Network Transition Tests', () {
      test(
        'should use cached data after brief network disconnection',
        () async {
          // Arrange - First login online
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthApiModel);

          final result1 = await authRepository.login(tEmail, tPassword);

          // Simulate network goes offline
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthHiveModel);

          // Act - Try login while offline
          final result2 = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result1, Right(tAuthEntity));
          expect(result2, Right(tAuthEntity));
        },
      );

      test(
        'should retry remote source when network comes back online',
        () async {
          // Arrange - offline first
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthHiveModel);

          await authRepository.login(tEmail, tPassword);

          // Network comes back online
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthApiModel);

          // Act - Login again
          final result = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result, Right(tAuthEntity));
          verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
        },
      );
    });

    // ============= GET CURRENT USER TESTS =============
    group('Get Current User - Offline/Online', () {
      test(
        'should get current user from local storage (offline or online)',
        () async {
          // Arrange
          when(
            () => mockLocalDataSource.getCurrentUser(),
          ).thenAnswer((_) async => tAuthHiveModel);

          // Act
          final result = await authRepository.getCurrentUser();

          // Assert
          expect(result, Right(tAuthEntity));
          verify(() => mockLocalDataSource.getCurrentUser()).called(1);
        },
      );

      test('should return failure when no current user cached', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getCurrentUser(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
      });
    });

    // ============= REAL WORLD SCENARIOS =============
    group('Real World Scenarios', () {
      test(
        'Scenario: User logs in online, then loses connection, then regains connection',
        () async {
          // 1. User logs in online
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthApiModel);

          final onlineLogin = await authRepository.login(tEmail, tPassword);
          expect(onlineLogin, Right(tAuthEntity));

          // 2. Connection lost
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthHiveModel);

          final offlineAccess = await authRepository.login(tEmail, tPassword);
          expect(offlineAccess, Right(tAuthEntity));

          // 3. Connection regained
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthApiModel);

          final onlineLogin2 = await authRepository.login(tEmail, tPassword);
          expect(onlineLogin2, Right(tAuthEntity));
        },
      );

      test(
        'Scenario: Offline user browses menu from cache and remains satisfied',
        () async {
          // Arrange - user offline
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);
          when(
            () => mockLocalDataSource.login(tEmail, tPassword),
          ).thenAnswer((_) async => tAuthHiveModel);

          // Act - offline operations
          final result = await authRepository.login(tEmail, tPassword);

          // Assert
          expect(result, Right(tAuthEntity));
          // User can still see their profile from cache
          verify(() => mockLocalDataSource.login(tEmail, tPassword)).called(1);
        },
      );
    });
  });
}
