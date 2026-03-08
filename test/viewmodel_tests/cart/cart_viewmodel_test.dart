import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock UseCase
class MockAddToCartUseCase extends Mock {
  Future<Either<Failure, void>> call(CartItem item);
}

class MockRemoveFromCartUseCase extends Mock {
  Future<Either<Failure, void>> call(String itemId);
}

class CartItem {
  final String id;
  final String name;
  final int quantity;
  CartItem(this.id, this.name, this.quantity);
}

// State classes
abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdating extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;
  CartUpdated(this.items);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

// ViewModel
class CartViewModel extends StateNotifier<CartState> {
  final MockAddToCartUseCase addToCartUseCase;
  final MockRemoveFromCartUseCase removeFromCartUseCase;
  List<CartItem> _items = [];

  CartViewModel(this.addToCartUseCase, this.removeFromCartUseCase)
    : super(CartInitial());

  Future<void> addItem(CartItem item) async {
    state = CartUpdating();
    final result = await addToCartUseCase(item);
    result.fold((failure) => state = CartError(failure.message), (_) {
      _items.add(item);
      state = CartUpdated(List.from(_items));
    });
  }

  Future<void> removeItem(String itemId) async {
    state = CartUpdating();
    final result = await removeFromCartUseCase(itemId);
    result.fold((failure) => state = CartError(failure.message), (_) {
      _items.removeWhere((item) => item.id == itemId);
      state = CartUpdated(List.from(_items));
    });
  }
}

void main() {
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
  late CartViewModel viewModel;

  setUp(() {
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockRemoveFromCartUseCase = MockRemoveFromCartUseCase();
    viewModel = CartViewModel(mockAddToCartUseCase, mockRemoveFromCartUseCase);
  });

  setUpAll(() {
    registerFallbackValue(CartItem('1', 'Test', 1));
  });

  group('Cart ViewModel Tests', () {
    test('initial state should be CartInitial', () {
      expect(viewModel.state, isA<CartInitial>());
    });

    test('should add item to cart successfully', () async {
      // Arrange
      final tItem = CartItem('1', 'Pizza', 2);
      when(
        () => mockAddToCartUseCase(tItem),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await viewModel.addItem(tItem);

      // Assert
      expect(viewModel.state, isA<CartUpdated>());
      expect((viewModel.state as CartUpdated).items.length, 1);
      verify(() => mockAddToCartUseCase(tItem)).called(1);
    });

    test('should emit CartError when adding item fails', () async {
      // Arrange
      final tItem = CartItem('1', 'Pizza', 2);
      const tFailure = LocalDatabaseFailure(message: 'Failed to add');
      when(
        () => mockAddToCartUseCase(tItem),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      await viewModel.addItem(tItem);

      // Assert
      expect(viewModel.state, isA<CartError>());
      expect((viewModel.state as CartError).message, 'Failed to add');
    });

    test('should remove item from cart successfully', () async {
      // Arrange
      final tItem = CartItem('1', 'Pizza', 2);
      when(
        () => mockAddToCartUseCase(tItem),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRemoveFromCartUseCase('1'),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await viewModel.addItem(tItem);
      await viewModel.removeItem('1');

      // Assert
      expect(viewModel.state, isA<CartUpdated>());
      expect((viewModel.state as CartUpdated).items.length, 0);
    });
  });
}
