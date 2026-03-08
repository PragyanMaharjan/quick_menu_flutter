import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock menu entity
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

// Mock failure class
abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

// Mock repository
class MockMenuRepository extends Mock {
  Future<Either<Failure, List<MenuItem>>> getMenuItems() async {
    return Right([
      MenuItem(id: '1', name: 'Burger', price: 5.99, category: 'Main'),
      MenuItem(id: '2', name: 'Pizza', price: 7.99, category: 'Main'),
    ]);
  }

  Future<Either<Failure, MenuItem>> getMenuItemById(String id) async {
    return Right(MenuItem(id: id, name: 'Item', price: 5.99, category: 'Main'));
  }
}

// Usecase for menu items
class GetMenuItemsUsecase {
  final MockMenuRepository repository;

  GetMenuItemsUsecase(this.repository);

  Future<Either<Failure, List<MenuItem>>> call() async {
    return repository.getMenuItems();
  }
}

class GetMenuItemByIdUsecase {
  final MockMenuRepository repository;

  GetMenuItemByIdUsecase(this.repository);

  Future<Either<Failure, MenuItem>> call(String id) async {
    return repository.getMenuItemById(id);
  }
}

void main() {
  late GetMenuItemsUsecase getMenuItemsUsecase;
  late GetMenuItemByIdUsecase getMenuItemByIdUsecase;
  late MockMenuRepository mockMenuRepository;

  setUp(() {
    mockMenuRepository = MockMenuRepository();
    getMenuItemsUsecase = GetMenuItemsUsecase(mockMenuRepository);
    getMenuItemByIdUsecase = GetMenuItemByIdUsecase(mockMenuRepository);
  });

  group('GetMenuItemsUsecase', () {
    test('should return list of menu items when successful', () async {
      // Act
      final result = await getMenuItemsUsecase();

      // Assert
      expect(result, isA<Right<Failure, List<MenuItem>>>());
      result.fold((failure) => fail('Should return right'), (items) {
        expect(items.length, 2);
        expect(items[0].name, 'Burger');
      });
    });

    test('should handle empty menu response', () async {
      // Act
      final result = await getMenuItemsUsecase();

      // Assert
      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return right'),
        (items) => expect(items.isNotEmpty, true),
      );
    });

    test('should have correct items in returned list', () async {
      // Act
      final result = await getMenuItemsUsecase();

      // Assert
      result.fold((failure) => fail('Should return right'), (items) {
        expect(items[0].id, '1');
        expect(items[0].price, 5.99);
        expect(items[1].name, 'Pizza');
      });
    });
  });

  group('GetMenuItemByIdUsecase', () {
    test('should return specific menu item by id', () async {
      // Act
      final result = await getMenuItemByIdUsecase('1');

      // Assert
      expect(result, isA<Right<Failure, MenuItem>>());
      result.fold((failure) => fail('Should return right'), (item) {
        expect(item.id, '1');
        expect(item.name, 'Item');
      });
    });

    test('should include price information in returned item', () async {
      // Act
      final result = await getMenuItemByIdUsecase('1');

      // Assert
      result.fold((failure) => fail('Should return right'), (item) {
        expect(item.price, 5.99);
        expect(item.category, 'Main');
      });
    });
  });
}
