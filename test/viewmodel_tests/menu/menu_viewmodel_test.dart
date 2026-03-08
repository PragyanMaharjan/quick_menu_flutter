import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock UseCase
class MockGetMenuItemsUseCase extends Mock {
  Future<Either<Failure, List<MenuItem>>> call();
}

class MockFilterMenuItemsUseCase extends Mock {
  Future<Either<Failure, List<MenuItem>>> call(String category);
}

class MenuItem {
  final String id;
  final String name;
  final String category;
  MenuItem(this.id, this.name, this.category);
}

// State classes
abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> items;
  MenuLoaded(this.items);
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);
}

// ViewModel
class MenuViewModel extends StateNotifier<MenuState> {
  final MockGetMenuItemsUseCase getMenuItemsUseCase;
  final MockFilterMenuItemsUseCase filterMenuItemsUseCase;

  MenuViewModel(this.getMenuItemsUseCase, this.filterMenuItemsUseCase)
    : super(MenuInitial());

  Future<void> loadMenuItems() async {
    state = MenuLoading();
    final result = await getMenuItemsUseCase();
    result.fold(
      (failure) => state = MenuError(failure.message),
      (items) => state = MenuLoaded(items),
    );
  }

  Future<void> filterByCategory(String category) async {
    state = MenuLoading();
    final result = await filterMenuItemsUseCase(category);
    result.fold(
      (failure) => state = MenuError(failure.message),
      (items) => state = MenuLoaded(items),
    );
  }
}

void main() {
  late MockGetMenuItemsUseCase mockGetMenuItemsUseCase;
  late MockFilterMenuItemsUseCase mockFilterMenuItemsUseCase;
  late MenuViewModel viewModel;

  setUp(() {
    mockGetMenuItemsUseCase = MockGetMenuItemsUseCase();
    mockFilterMenuItemsUseCase = MockFilterMenuItemsUseCase();
    viewModel = MenuViewModel(
      mockGetMenuItemsUseCase,
      mockFilterMenuItemsUseCase,
    );
  });

  group('Menu ViewModel Tests', () {
    test('initial state should be MenuInitial', () {
      expect(viewModel.state, isA<MenuInitial>());
    });

    test('should load menu items successfully', () async {
      // Arrange
      final tItems = [
        MenuItem('1', 'Pizza', 'main'),
        MenuItem('2', 'Burger', 'main'),
      ];
      when(
        () => mockGetMenuItemsUseCase(),
      ).thenAnswer((_) async => Right(tItems));

      // Act
      await viewModel.loadMenuItems();

      // Assert
      expect(viewModel.state, isA<MenuLoaded>());
      expect((viewModel.state as MenuLoaded).items, tItems);
    });

    test('should filter menu items by category', () async {
      // Arrange
      final tMainItems = [MenuItem('1', 'Pizza', 'main')];
      when(
        () => mockFilterMenuItemsUseCase('main'),
      ).thenAnswer((_) async => Right(tMainItems));

      // Act
      await viewModel.filterByCategory('main');

      // Assert
      expect(viewModel.state, isA<MenuLoaded>());
      expect((viewModel.state as MenuLoaded).items.length, 1);
    });

    test('should emit MenuError when loading fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Network error');
      when(
        () => mockGetMenuItemsUseCase(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      await viewModel.loadMenuItems();

      // Assert
      expect(viewModel.state, isA<MenuError>());
    });
  });
}
