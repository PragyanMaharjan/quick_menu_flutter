import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockSearchRemoteDataSource extends Mock {
  Future<SearchResult> searchItems(String query);
  Future<List<SearchSuggestion>> getSearchSuggestions(String partial);
}

class MockSearchLocalStorage extends Mock {
  Future<void> saveSearchHistory(String query);
  Future<List<String>> getSearchHistory();
  Future<void> clearSearchHistory();
}

class SearchResult {
  final List<SearchItem> items;
  final int totalCount;
  SearchResult(this.items, this.totalCount);
}

class SearchItem {
  final String id;
  final String name;
  final double price;
  SearchItem(this.id, this.name, this.price);
}

class SearchSuggestion {
  final String text;
  final int matchCount;
  SearchSuggestion(this.text, this.matchCount);
}

// Repository
class SearchRepository {
  final MockSearchRemoteDataSource remoteDataSource;
  final MockSearchLocalStorage localStorage;

  SearchRepository(this.remoteDataSource, this.localStorage);

  Future<Either<Failure, SearchResult>> searchItems(String query) async {
    try {
      final result = await remoteDataSource.searchItems(query);
      await localStorage.saveSearchHistory(query);
      return Right(result);
    } catch (e) {
      return const Left(ApiFailure(message: 'Search failed'));
    }
  }

  Future<Either<Failure, List<SearchSuggestion>>> getSuggestions(
    String partial,
  ) async {
    try {
      final suggestions = await remoteDataSource.getSearchSuggestions(partial);
      return Right(suggestions);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to get suggestions'));
    }
  }

  Future<Either<Failure, List<String>>> getSearchHistory() async {
    try {
      final history = await localStorage.getSearchHistory();
      return Right(history);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to get history'));
    }
  }

  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await localStorage.clearSearchHistory();
      return const Right(null);
    } catch (e) {
      return const Left(
        LocalDatabaseFailure(message: 'Failed to clear history'),
      );
    }
  }
}

void main() {
  late MockSearchRemoteDataSource mockRemoteDataSource;
  late MockSearchLocalStorage mockLocalStorage;
  late SearchRepository repository;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    mockLocalStorage = MockSearchLocalStorage();
    repository = SearchRepository(mockRemoteDataSource, mockLocalStorage);
  });

  group('Search Repository Integration Tests', () {
    final tSearchResult = SearchResult([
      SearchItem('1', 'Pizza', 500.0),
      SearchItem('2', 'Pasta', 400.0),
    ], 2);
    final tSuggestions = [
      SearchSuggestion('Pizza', 5),
      SearchSuggestion('Pasta', 3),
    ];

    test('should search items and save query to history', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.searchItems('pizza'),
      ).thenAnswer((_) async => tSearchResult);
      when(
        () => mockLocalStorage.saveSearchHistory('pizza'),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.searchItems('pizza');

      // Assert
      expect(result, Right(tSearchResult));
      verify(() => mockRemoteDataSource.searchItems('pizza')).called(1);
      verify(() => mockLocalStorage.saveSearchHistory('pizza')).called(1);
    });

    test('should get search suggestions', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getSearchSuggestions('piz'),
      ).thenAnswer((_) async => tSuggestions);

      // Act
      final result = await repository.getSuggestions('piz');

      // Assert
      expect(result, Right(tSuggestions));
      verify(() => mockRemoteDataSource.getSearchSuggestions('piz')).called(1);
    });

    test('should get search history from local storage', () async {
      // Arrange
      final tHistory = ['pizza', 'burger', 'pasta'];
      when(
        () => mockLocalStorage.getSearchHistory(),
      ).thenAnswer((_) async => tHistory);

      // Act
      final result = await repository.getSearchHistory();

      // Assert
      expect(result, Right(tHistory));
      verify(() => mockLocalStorage.getSearchHistory()).called(1);
    });

    test('should clear search history', () async {
      // Arrange
      when(
        () => mockLocalStorage.clearSearchHistory(),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.clearSearchHistory();

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.clearSearchHistory()).called(1);
    });
  });
}
