import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockTableRemoteDataSource extends Mock {
  Future<TableData> getTableInfo(String tableId);
  Future<bool> verifyTableQR(String qrCode);
}

class MockTableLocalStorage extends Mock {
  Future<void> saveCurrentTable(TableData table);
  Future<TableData?> getCurrentTable();
  Future<void> clearCurrentTable();
}

class TableData {
  final String id;
  final int tableNumber;
  final String section;
  final bool isAvailable;
  TableData(this.id, this.tableNumber, this.section, this.isAvailable);
}

// Repository
class TableRepository {
  final MockTableRemoteDataSource remoteDataSource;
  final MockTableLocalStorage localStorage;

  TableRepository(this.remoteDataSource, this.localStorage);

  Future<Either<Failure, TableData>> scanTableQR(String qrCode) async {
    try {
      // Verify QR code
      final isValid = await remoteDataSource.verifyTableQR(qrCode);
      if (!isValid) {
        return const Left(ApiFailure(message: 'Invalid QR code'));
      }

      // Get table info
      final table = await remoteDataSource.getTableInfo(qrCode);
      await localStorage.saveCurrentTable(table);
      return Right(table);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to scan table'));
    }
  }

  Future<Either<Failure, TableData?>> getCurrentTable() async {
    try {
      final table = await localStorage.getCurrentTable();
      return Right(table);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to get table'));
    }
  }

  Future<Either<Failure, void>> leaveTable() async {
    try {
      await localStorage.clearCurrentTable();
      return const Right(null);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to leave table'));
    }
  }
}

void main() {
  late MockTableRemoteDataSource mockRemoteDataSource;
  late MockTableLocalStorage mockLocalStorage;
  late TableRepository repository;

  setUp(() {
    mockRemoteDataSource = MockTableRemoteDataSource();
    mockLocalStorage = MockTableLocalStorage();
    repository = TableRepository(mockRemoteDataSource, mockLocalStorage);
  });

  setUpAll(() {
    registerFallbackValue(TableData('1', 5, 'A', true));
  });

  group('Table Repository Integration Tests', () {
    final tTable = TableData('T001', 5, 'Section A', true);
    const tQRCode = 'QR_TABLE_T001';

    test('should scan QR code, verify, get table info and save', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.verifyTableQR(tQRCode),
      ).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.getTableInfo(tQRCode),
      ).thenAnswer((_) async => tTable);
      when(
        () => mockLocalStorage.saveCurrentTable(tTable),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.scanTableQR(tQRCode);

      // Assert
      expect(result, Right(tTable));
      verify(() => mockRemoteDataSource.verifyTableQR(tQRCode)).called(1);
      verify(() => mockRemoteDataSource.getTableInfo(tQRCode)).called(1);
      verify(() => mockLocalStorage.saveCurrentTable(tTable)).called(1);
    });

    test('should return failure for invalid QR code', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.verifyTableQR(tQRCode),
      ).thenAnswer((_) async => false);

      // Act
      final result = await repository.scanTableQR(tQRCode);

      // Assert
      expect(result.isLeft(), true);
      verifyNever(() => mockRemoteDataSource.getTableInfo(any()));
    });

    test('should get current table from storage', () async {
      // Arrange
      when(
        () => mockLocalStorage.getCurrentTable(),
      ).thenAnswer((_) async => tTable);

      // Act
      final result = await repository.getCurrentTable();

      // Assert
      expect(result, Right(tTable));
      verify(() => mockLocalStorage.getCurrentTable()).called(1);
    });

    test('should clear current table when leaving', () async {
      // Arrange
      when(
        () => mockLocalStorage.clearCurrentTable(),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.leaveTable();

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.clearCurrentTable()).called(1);
    });
  });
}
