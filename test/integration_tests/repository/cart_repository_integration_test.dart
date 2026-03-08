import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockCartLocalStorage extends Mock {
  Future<List<CartItemData>> getCartItems();
  Future<void> addItem(CartItemData item);
  Future<void> removeItem(String itemId);
  Future<void> clearCart();
  Future<void> updateQuantity(String itemId, int quantity);
}

class CartItemData {
  final String id;
  final String name;
  final double price;
  final int quantity;
  CartItemData(this.id, this.name, this.price, this.quantity);
}

// Repository
class CartRepository {
  final MockCartLocalStorage localStorage;

  CartRepository(this.localStorage);

  Future<Either<Failure, void>> addToCart(CartItemData item) async {
    try {
      await localStorage.addItem(item);
      return const Right(null);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to add item'));
    }
  }

  Future<Either<Failure, List<CartItemData>>> getCartItems() async {
    try {
      final items = await localStorage.getCartItems();
      return Right(items);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to get items'));
    }
  }

  Future<Either<Failure, void>> updateItemQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      await localStorage.updateQuantity(itemId, quantity);
      return const Right(null);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to update'));
    }
  }

  Future<Either<Failure, void>> removeFromCart(String itemId) async {
    try {
      await localStorage.removeItem(itemId);
      return const Right(null);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to remove'));
    }
  }

  Future<Either<Failure, void>> clearCart() async {
    try {
      await localStorage.clearCart();
      return const Right(null);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to clear'));
    }
  }
}

void main() {
  late MockCartLocalStorage mockLocalStorage;
  late CartRepository repository;

  setUp(() {
    mockLocalStorage = MockCartLocalStorage();
    repository = CartRepository(mockLocalStorage);
  });

  setUpAll(() {
    registerFallbackValue(CartItemData('1', 'Test', 0, 0));
  });

  group('Cart Repository Integration Tests', () {
    final tCartItem = CartItemData('1', 'Pizza', 500.0, 2);

    test('should add item to cart successfully', () async {
      // Arrange
      when(
        () => mockLocalStorage.addItem(tCartItem),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.addToCart(tCartItem);

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.addItem(tCartItem)).called(1);
    });

    test('should get all cart items', () async {
      // Arrange
      final tItems = [tCartItem];
      when(
        () => mockLocalStorage.getCartItems(),
      ).thenAnswer((_) async => tItems);

      // Act
      final result = await repository.getCartItems();

      // Assert
      expect(result, Right(tItems));
      verify(() => mockLocalStorage.getCartItems()).called(1);
    });

    test('should update item quantity', () async {
      // Arrange
      when(
        () => mockLocalStorage.updateQuantity('1', 5),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.updateItemQuantity('1', 5);

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.updateQuantity('1', 5)).called(1);
    });

    test('should remove item from cart', () async {
      // Arrange
      when(() => mockLocalStorage.removeItem('1')).thenAnswer((_) async => {});

      // Act
      final result = await repository.removeFromCart('1');

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.removeItem('1')).called(1);
    });

    test('should clear entire cart', () async {
      // Arrange
      when(() => mockLocalStorage.clearCart()).thenAnswer((_) async => {});

      // Act
      final result = await repository.clearCart();

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.clearCart()).called(1);
    });
  });
}
