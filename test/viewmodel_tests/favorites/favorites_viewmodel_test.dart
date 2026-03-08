import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockFavoritesUseCase extends Mock {
  Future<Either<Failure, List<FavoriteItem>>> getFavorites(String userId);
  Future<Either<Failure, void>> addToFavorites(String userId, String itemId);
  Future<Either<Failure, void>> removeFromFavorites(
    String userId,
    String itemId,
  );
}

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  FavoriteItem(this.id, this.name, this.price);
}

// State
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}

// ViewModel
class FavoritesViewModel extends StateNotifier<FavoritesState> {
  final MockFavoritesUseCase favoritesUseCase;

  FavoritesViewModel(this.favoritesUseCase) : super(FavoritesInitial());

  Future<void> loadFavorites(String userId) async {
    state = FavoritesLoading();
    final result = await favoritesUseCase.getFavorites(userId);
    result.fold(
      (failure) => state = FavoritesError(failure.message),
      (favorites) => state = FavoritesLoaded(favorites),
    );
  }

  Future<void> addToFavorites(String userId, String itemId) async {
    final result = await favoritesUseCase.addToFavorites(userId, itemId);
    if (result.isLeft()) {
      result.fold((failure) => state = FavoritesError(failure.message), (_) {});
      return;
    }

    await loadFavorites(userId);
  }

  Future<void> removeFromFavorites(String userId, String itemId) async {
    final result = await favoritesUseCase.removeFromFavorites(userId, itemId);
    if (result.isLeft()) {
      result.fold((failure) => state = FavoritesError(failure.message), (_) {});
      return;
    }

    await loadFavorites(userId);
  }
}

void main() {
  late MockFavoritesUseCase mockFavoritesUseCase;
  late FavoritesViewModel viewModel;

  setUp(() {
    mockFavoritesUseCase = MockFavoritesUseCase();
    viewModel = FavoritesViewModel(mockFavoritesUseCase);
  });

  group('Favorites ViewModel Tests', () {
    final tFavorites = [
      FavoriteItem('1', 'Pizza', 500.0),
      FavoriteItem('2', 'Burger', 300.0),
    ];

    test('should emit initial state', () {
      // Assert
      expect(viewModel.state, isA<FavoritesInitial>());
    });

    test('should load favorites successfully', () async {
      // Arrange
      when(
        () => mockFavoritesUseCase.getFavorites('user123'),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await viewModel.loadFavorites('user123');

      // Assert
      expect(viewModel.state, isA<FavoritesLoaded>());
      final state = viewModel.state as FavoritesLoaded;
      expect(state.favorites.length, 2);
      verify(() => mockFavoritesUseCase.getFavorites('user123')).called(1);
    });

    test('should emit error state when loading fails', () async {
      // Arrange
      when(() => mockFavoritesUseCase.getFavorites('user123')).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Failed to load')),
      );

      // Act
      await viewModel.loadFavorites('user123');

      // Assert
      expect(viewModel.state, isA<FavoritesError>());
      verify(() => mockFavoritesUseCase.getFavorites('user123')).called(1);
    });

    test('should add to favorites and reload', () async {
      // Arrange
      when(
        () => mockFavoritesUseCase.addToFavorites('user123', 'item456'),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockFavoritesUseCase.getFavorites('user123'),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await viewModel.addToFavorites('user123', 'item456');

      // Assert
      expect(viewModel.state, isA<FavoritesLoaded>());
      verify(
        () => mockFavoritesUseCase.addToFavorites('user123', 'item456'),
      ).called(1);
      verify(() => mockFavoritesUseCase.getFavorites('user123')).called(1);
    });

    test('should remove from favorites and reload', () async {
      // Arrange
      when(
        () => mockFavoritesUseCase.removeFromFavorites('user123', 'item456'),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockFavoritesUseCase.getFavorites('user123'),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      await viewModel.removeFromFavorites('user123', 'item456');

      // Assert
      expect(viewModel.state, isA<FavoritesLoaded>());
      verify(
        () => mockFavoritesUseCase.removeFromFavorites('user123', 'item456'),
      ).called(1);
      verify(() => mockFavoritesUseCase.getFavorites('user123')).called(1);
    });
  });
}
