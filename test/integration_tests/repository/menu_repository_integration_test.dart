import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockMenuLocalDataSource extends Mock {
  Future<List<MenuItemData>> getCachedMenuItems();
  Future<void> cacheMenuItems(List<MenuItemData> items);
}

class MockMenuRemoteDataSource extends Mock {
  Future<List<MenuItemData>> getMenuItems();
}

class MenuItemData {
  final String id;
  final String name;
  final double price;
  MenuItemData(this.id, this.name, this.price);
}

// Repository
class MenuRepository {
  final MockMenuLocalDataSource localDataSource;
  final MockMenuRemoteDataSource remoteDataSource;

  MenuRepository(this.localDataSource, this.remoteDataSource);

  Future<Either<Failure, List<MenuItemData>>> getMenuItems() async {
    try {
      // Try to get from remote
      final remoteItems = await remoteDataSource.getMenuItems();
      await localDataSource.cacheMenuItems(remoteItems);
      return Right(remoteItems);
    } catch (e) {
      // Fallback to cached data
      try {
        final cachedItems = await localDataSource.getCachedMenuItems();
        return Right(cachedItems);
      } catch (cacheError) {
        return const Left(LocalDatabaseFailure(message: 'No data available'));
      }
    }
  }
}

void main() {
  late MockMenuLocalDataSource mockLocalDataSource;
  late MockMenuRemoteDataSource mockRemoteDataSource;
  late MenuRepository repository;

  setUp(() {
    mockLocalDataSource = MockMenuLocalDataSource();
    mockRemoteDataSource = MockMenuRemoteDataSource();
    repository = MenuRepository(mockLocalDataSource, mockRemoteDataSource);
  });

  group('Menu Repository Integration Tests', () {
    final tMenuItems = [
      MenuItemData('1', 'Pizza', 500.0),
      MenuItemData('2', 'Burger', 300.0),
    ];

    test('should get menu items from remote and cache them', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getMenuItems(),
      ).thenAnswer((_) async => tMenuItems);
      when(
        () => mockLocalDataSource.cacheMenuItems(tMenuItems),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.getMenuItems();

      // Assert
      expect(result, Right(tMenuItems));
      verify(() => mockRemoteDataSource.getMenuItems()).called(1);
      verify(() => mockLocalDataSource.cacheMenuItems(tMenuItems)).called(1);
    });

    test('should fallback to cached data when remote fails', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getMenuItems(),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockLocalDataSource.getCachedMenuItems(),
      ).thenAnswer((_) async => tMenuItems);

      // Act
      final result = await repository.getMenuItems();

      // Assert
      expect(result, Right(tMenuItems));
      verify(() => mockLocalDataSource.getCachedMenuItems()).called(1);
    });

    test('should return failure when both remote and cache fail', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getMenuItems(),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockLocalDataSource.getCachedMenuItems(),
      ).thenThrow(Exception('Cache error'));

      // Act
      final result = await repository.getMenuItems();

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
