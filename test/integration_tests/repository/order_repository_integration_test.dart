import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockLocalDataSource extends Mock {
  Future<List<OrderData>> getLocalOrders();
  Future<void> saveOrder(OrderData order);
}

class MockRemoteDataSource extends Mock {
  Future<List<OrderData>> getRemoteOrders();
}

class MockNetworkInfo extends Mock {
  Future<bool> get isConnected;
}

class OrderData {
  final String id;
  final double total;
  OrderData(this.id, this.total);
}

// Repository
class OrderRepository {
  final MockLocalDataSource localDataSource;
  final MockRemoteDataSource remoteDataSource;
  final MockNetworkInfo networkInfo;

  OrderRepository(
    this.localDataSource,
    this.remoteDataSource,
    this.networkInfo,
  );

  Future<Either<Failure, List<OrderData>>> getOrders() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        final remoteOrders = await remoteDataSource.getRemoteOrders();
        // Save to local
        for (final order in remoteOrders) {
          await localDataSource.saveOrder(order);
        }
        return Right(remoteOrders);
      } else {
        final localOrders = await localDataSource.getLocalOrders();
        return Right(localOrders);
      }
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to get orders'));
    }
  }
}

void main() {
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late OrderRepository repository;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = OrderRepository(
      mockLocalDataSource,
      mockRemoteDataSource,
      mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(OrderData('1', 0));
  });

  group('Order Repository Integration Tests', () {
    final tOrders = [OrderData('1', 100.0), OrderData('2', 200.0)];

    test('should get orders from remote when device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.getRemoteOrders(),
      ).thenAnswer((_) async => tOrders);
      when(
        () => mockLocalDataSource.saveOrder(any()),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getOrders();

      // Assert
      expect(result, Right(tOrders));
      verify(() => mockRemoteDataSource.getRemoteOrders()).called(1);
      verify(() => mockLocalDataSource.saveOrder(any())).called(2);
    });

    test('should get orders from local when device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getLocalOrders(),
      ).thenAnswer((_) async => tOrders);

      // Act
      final result = await repository.getOrders();

      // Assert
      expect(result, Right(tOrders));
      verify(() => mockLocalDataSource.getLocalOrders()).called(1);
      verifyNever(() => mockRemoteDataSource.getRemoteOrders());
    });

    test('should return failure when remote call fails', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.getRemoteOrders(),
      ).thenThrow(Exception('Network error'));

      // Act
      final result = await repository.getOrders();

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
