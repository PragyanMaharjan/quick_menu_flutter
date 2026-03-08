import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockCartRepository extends Mock {
  Future<Either<Failure, void>> addToCart(CartItem item);
  Future<Either<Failure, void>> removeFromCart(String itemId);
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> clearCart();
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class AddToCartUseCase {
  final MockCartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, void>> call(CartItem item) {
    return repository.addToCart(item);
  }
}

class RemoveFromCartUseCase {
  final MockCartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemId) {
    return repository.removeFromCart(itemId);
  }
}

class ClearCartUseCase {
  final MockCartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.clearCart();
  }
}

void main() {
  late MockCartRepository mockRepository;
  late AddToCartUseCase addToCartUseCase;
  late RemoveFromCartUseCase removeFromCartUseCase;
  late ClearCartUseCase clearCartUseCase;

  setUp(() {
    mockRepository = MockCartRepository();
    addToCartUseCase = AddToCartUseCase(mockRepository);
    removeFromCartUseCase = RemoveFromCartUseCase(mockRepository);
    clearCartUseCase = ClearCartUseCase(mockRepository);
  });

  group('Add To Cart UseCase Tests', () {
    final tCartItem = CartItem(
      id: '1',
      name: 'Pizza',
      price: 500.0,
      quantity: 2,
    );

    test('should add item to cart successfully', () async {
      // Arrange
      when(
        () => mockRepository.addToCart(tCartItem),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await addToCartUseCase(tCartItem);

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.addToCart(tCartItem)).called(1);
    });

    test('should return failure when adding item fails', () async {
      // Arrange
      const tFailure = LocalDatabaseFailure(message: 'Failed to add item');
      when(
        () => mockRepository.addToCart(tCartItem),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await addToCartUseCase(tCartItem);

      // Assert
      expect(result, const Left(tFailure));
    });
  });

  group('Remove From Cart UseCase Tests', () {
    test('should remove item from cart successfully', () async {
      // Arrange
      when(
        () => mockRepository.removeFromCart('1'),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await removeFromCartUseCase('1');

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.removeFromCart('1')).called(1);
    });
  });

  group('Clear Cart UseCase Tests', () {
    test('should clear all items from cart', () async {
      // Arrange
      when(
        () => mockRepository.clearCart(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await clearCartUseCase();

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.clearCart()).called(1);
    });
  });
}
