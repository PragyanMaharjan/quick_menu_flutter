import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockMenuRepository extends Mock {
  Future<Either<Failure, List<MenuItem>>> getMenuItems();
  Future<Either<Failure, MenuItem>> getMenuItemById(String id);
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
    String category,
  );
}

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String category;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });
}

class GetMenuItemsUseCase {
  final MockMenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  Future<Either<Failure, List<MenuItem>>> call() {
    return repository.getMenuItems();
  }
}

class GetMenuItemByCategoryUseCase {
  final MockMenuRepository repository;

  GetMenuItemByCategoryUseCase(this.repository);

  Future<Either<Failure, List<MenuItem>>> call(String category) {
    return repository.getMenuItemsByCategory(category);
  }
}

void main() {
  late MockMenuRepository mockRepository;
  late GetMenuItemsUseCase getMenuItemsUseCase;
  late GetMenuItemByCategoryUseCase getMenuItemByCategoryUseCase;

  setUp(() {
    mockRepository = MockMenuRepository();
    getMenuItemsUseCase = GetMenuItemsUseCase(mockRepository);
    getMenuItemByCategoryUseCase = GetMenuItemByCategoryUseCase(mockRepository);
  });

  group('Get Menu Items UseCase Tests', () {
    final tMenuItems = [
      MenuItem(id: '1', name: 'Pizza', price: 500.0, category: 'main'),
      MenuItem(id: '2', name: 'Burger', price: 300.0, category: 'main'),
    ];

    test('should get all menu items from repository', () async {
      // Arrange
      when(
        () => mockRepository.getMenuItems(),
      ).thenAnswer((_) async => Right(tMenuItems));

      // Act
      final result = await getMenuItemsUseCase();

      // Assert
      expect(result, Right(tMenuItems));
      verify(() => mockRepository.getMenuItems()).called(1);
    });

    test('should return failure when fetching menu items fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Failed to load menu');
      when(
        () => mockRepository.getMenuItems(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await getMenuItemsUseCase();

      // Assert
      expect(result, const Left(tFailure));
    });
  });

  group('Get Menu Items By Category UseCase Tests', () {
    final tMainCourseItems = [
      MenuItem(id: '1', name: 'Pizza', price: 500.0, category: 'main'),
      MenuItem(id: '2', name: 'Burger', price: 300.0, category: 'main'),
    ];

    test('should get menu items filtered by category', () async {
      // Arrange
      when(
        () => mockRepository.getMenuItemsByCategory('main'),
      ).thenAnswer((_) async => Right(tMainCourseItems));

      // Act
      final result = await getMenuItemByCategoryUseCase('main');

      // Assert
      expect(result, Right(tMainCourseItems));
      verify(() => mockRepository.getMenuItemsByCategory('main')).called(1);
    });

    test('should return empty list when category has no items', () async {
      // Arrange
      when(
        () => mockRepository.getMenuItemsByCategory('dessert'),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await getMenuItemByCategoryUseCase('dessert');

      // Assert
      result.fold(
        (failure) => fail('Expected Right with empty list, got Left: $failure'),
        (items) => expect(items, isEmpty),
      );
    });
  });
}
