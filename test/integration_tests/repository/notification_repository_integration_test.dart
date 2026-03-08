import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockNotificationRemoteDataSource extends Mock {
  Future<List<NotificationData>> getNotifications(String userId);
  Future<void> markAsRead(String notificationId);
}

class MockNotificationLocalStorage extends Mock {
  Future<void> cacheNotifications(List<NotificationData> notifications);
  Future<List<NotificationData>> getCachedNotifications();
  Future<void> updateNotificationStatus(String id, bool isRead);
}

class NotificationData {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime timestamp;
  NotificationData(
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.timestamp,
  );
}

// Repository
class NotificationRepository {
  final MockNotificationRemoteDataSource remoteDataSource;
  final MockNotificationLocalStorage localStorage;

  NotificationRepository(this.remoteDataSource, this.localStorage);

  Future<Either<Failure, List<NotificationData>>> getNotifications(
    String userId,
  ) async {
    try {
      final notifications = await remoteDataSource.getNotifications(userId);
      await localStorage.cacheNotifications(notifications);
      return Right(notifications);
    } catch (e) {
      try {
        final cached = await localStorage.getCachedNotifications();
        return Right(cached);
      } catch (cacheError) {
        return const Left(ApiFailure(message: 'Failed to get notifications'));
      }
    }
  }

  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      await localStorage.updateNotificationStatus(notificationId, true);
      return const Right(null);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to mark as read'));
    }
  }
}

void main() {
  late MockNotificationRemoteDataSource mockRemoteDataSource;
  late MockNotificationLocalStorage mockLocalStorage;
  late NotificationRepository repository;

  setUp(() {
    mockRemoteDataSource = MockNotificationRemoteDataSource();
    mockLocalStorage = MockNotificationLocalStorage();
    repository = NotificationRepository(mockRemoteDataSource, mockLocalStorage);
  });

  setUpAll(() {
    registerFallbackValue(<NotificationData>[]);
  });

  group('Notification Repository Integration Tests', () {
    final tNotifications = [
      NotificationData(
        '1',
        'Order Ready',
        'Your order is ready',
        false,
        DateTime.now(),
      ),
      NotificationData('2', 'New Offer', '20% discount', false, DateTime.now()),
    ];

    test('should get notifications from remote and cache them', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getNotifications('user123'),
      ).thenAnswer((_) async => tNotifications);
      when(
        () => mockLocalStorage.cacheNotifications(tNotifications),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getNotifications('user123');

      // Assert
      expect(result, Right(tNotifications));
      verify(() => mockRemoteDataSource.getNotifications('user123')).called(1);
      verify(
        () => mockLocalStorage.cacheNotifications(tNotifications),
      ).called(1);
    });

    test('should fallback to cached notifications when remote fails', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getNotifications('user123'),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockLocalStorage.getCachedNotifications(),
      ).thenAnswer((_) async => tNotifications);

      // Act
      final result = await repository.getNotifications('user123');

      // Assert
      expect(result, Right(tNotifications));
      verify(() => mockLocalStorage.getCachedNotifications()).called(1);
    });

    test('should mark notification as read on both remote and local', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.markAsRead('1'),
      ).thenAnswer((_) async => {});
      when(
        () => mockLocalStorage.updateNotificationStatus('1', true),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.markAsRead('1');

      // Assert
      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.markAsRead('1')).called(1);
      verify(
        () => mockLocalStorage.updateNotificationStatus('1', true),
      ).called(1);
    });
  });
}
