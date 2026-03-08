import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockFavoritesRepository extends Mock {
  Future<Either<Failure, List<FavoriteItem>>> getFavorites(String userId);
  Future<Either<Failure, void>> addToFavorites(String userId, String itemId);
  Future<Either<Failure, void>> removeFromFavorites(
    String userId,
    String itemId,
  );
  Future<Either<Failure, bool>> isFavorite(String userId, String itemId);
}

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  FavoriteItem(this.id, this.name, this.price, this.imageUrl);
}

// Use Cases
class GetFavoritesUseCase {
  final MockFavoritesRepository repository;
  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<FavoriteItem>>> call(String userId) async {
    return await repository.getFavorites(userId);
  }
}

class AddToFavoritesUseCase {
  final MockFavoritesRepository repository;
  AddToFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, String itemId) async {
    return await repository.addToFavorites(userId, itemId);
  }
}

class RemoveFromFavoritesUseCase {
  final MockFavoritesRepository repository;
  RemoveFromFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, String itemId) async {
    return await repository.removeFromFavorites(userId, itemId);
  }
}

class IsFavoriteUseCase {
  final MockFavoritesRepository repository;
  IsFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String userId, String itemId) async {
    return await repository.isFavorite(userId, itemId);
  }
}

void main() {
  late MockFavoritesRepository mockRepository;
  late GetFavoritesUseCase getFavoritesUseCase;
  late AddToFavoritesUseCase addToFavoritesUseCase;
  late RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  late IsFavoriteUseCase isFavoriteUseCase;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    getFavoritesUseCase = GetFavoritesUseCase(mockRepository);
    addToFavoritesUseCase = AddToFavoritesUseCase(mockRepository);
    removeFromFavoritesUseCase = RemoveFromFavoritesUseCase(mockRepository);
    isFavoriteUseCase = IsFavoriteUseCase(mockRepository);
  });

  group('Get Favorites UseCase Tests', () {
    final tFavorites = [
      FavoriteItem('1', 'Pizza', 500.0, 'pizza.jpg'),
      FavoriteItem('2', 'Burger', 300.0, 'burger.jpg'),
    ];

    test('should get user favorites successfully', () async {
      // Arrange
      when(
        () => mockRepository.getFavorites('user123'),
      ).thenAnswer((_) async => Right(tFavorites));

      // Act
      final result = await getFavoritesUseCase('user123');

      // Assert
      expect(result, Right(tFavorites));
      verify(() => mockRepository.getFavorites('user123')).called(1);
    });

    test('should return failure when getting favorites fails', () async {
      // Arrange
      when(() => mockRepository.getFavorites('user123')).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Failed to load favorites')),
      );

      // Act
      final result = await getFavoritesUseCase('user123');

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.getFavorites('user123')).called(1);
    });
  });

  group('Add To Favorites UseCase Tests', () {
    test('should add item to favorites successfully', () async {
      // Arrange
      when(
        () => mockRepository.addToFavorites('user123', 'item456'),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await addToFavoritesUseCase('user123', 'item456');

      // Assert
      expect(result, const Right(null));
      verify(
        () => mockRepository.addToFavorites('user123', 'item456'),
      ).called(1);
    });

    test('should return failure when adding to favorites fails', () async {
      // Arrange
      when(
        () => mockRepository.addToFavorites('user123', 'item456'),
      ).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Failed to add favorite')),
      );

      // Act
      final result = await addToFavoritesUseCase('user123', 'item456');

      // Assert
      expect(result.isLeft(), true);
      verify(
        () => mockRepository.addToFavorites('user123', 'item456'),
      ).called(1);
    });
  });

  group('Remove From Favorites UseCase Tests', () {
    test('should remove item from favorites successfully', () async {
      // Arrange
      when(
        () => mockRepository.removeFromFavorites('user123', 'item456'),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await removeFromFavoritesUseCase('user123', 'item456');

      // Assert
      expect(result, const Right(null));
      verify(
        () => mockRepository.removeFromFavorites('user123', 'item456'),
      ).called(1);
    });

    test('should return failure when removing from favorites fails', () async {
      // Arrange
      when(
        () => mockRepository.removeFromFavorites('user123', 'item456'),
      ).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Failed to remove favorite')),
      );

      // Act
      final result = await removeFromFavoritesUseCase('user123', 'item456');

      // Assert
      expect(result.isLeft(), true);
      verify(
        () => mockRepository.removeFromFavorites('user123', 'item456'),
      ).called(1);
    });
  });

  group('Is Favorite UseCase Tests', () {
    test('should check if item is favorite successfully', () async {
      // Arrange
      when(
        () => mockRepository.isFavorite('user123', 'item456'),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await isFavoriteUseCase('user123', 'item456');

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.isFavorite('user123', 'item456')).called(1);
    });

    test('should return false when item is not favorite', () async {
      // Arrange
      when(
        () => mockRepository.isFavorite('user123', 'item456'),
      ).thenAnswer((_) async => const Right(false));

      // Act
      final result = await isFavoriteUseCase('user123', 'item456');

      // Assert
      expect(result, const Right(false));
      verify(() => mockRepository.isFavorite('user123', 'item456')).called(1);
    });
  });
}
