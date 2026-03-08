import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockCouponRemoteDataSource extends Mock {
  Future<List<CouponData>> getAvailableCoupons();
  Future<CouponData> applyCoupon(String code);
}

class MockCouponLocalStorage extends Mock {
  Future<void> saveAppliedCoupon(CouponData coupon);
  Future<CouponData?> getAppliedCoupon();
  Future<void> clearAppliedCoupon();
}

class CouponData {
  final String code;
  final double discount;
  final String type; // percentage or fixed
  CouponData(this.code, this.discount, this.type);
}

// Repository
class CouponRepository {
  final MockCouponRemoteDataSource remoteDataSource;
  final MockCouponLocalStorage localStorage;

  CouponRepository(this.remoteDataSource, this.localStorage);

  Future<Either<Failure, List<CouponData>>> getAvailableCoupons() async {
    try {
      final coupons = await remoteDataSource.getAvailableCoupons();
      return Right(coupons);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to get coupons'));
    }
  }

  Future<Either<Failure, CouponData>> applyCoupon(String code) async {
    try {
      final coupon = await remoteDataSource.applyCoupon(code);
      await localStorage.saveAppliedCoupon(coupon);
      return Right(coupon);
    } catch (e) {
      return const Left(ApiFailure(message: 'Invalid coupon code'));
    }
  }

  Future<Either<Failure, void>> removeCoupon() async {
    try {
      await localStorage.clearAppliedCoupon();
      return const Right(null);
    } catch (e) {
      return const Left(
        LocalDatabaseFailure(message: 'Failed to remove coupon'),
      );
    }
  }
}

void main() {
  late MockCouponRemoteDataSource mockRemoteDataSource;
  late MockCouponLocalStorage mockLocalStorage;
  late CouponRepository repository;

  setUp(() {
    mockRemoteDataSource = MockCouponRemoteDataSource();
    mockLocalStorage = MockCouponLocalStorage();
    repository = CouponRepository(mockRemoteDataSource, mockLocalStorage);
  });

  setUpAll(() {
    registerFallbackValue(CouponData('TEST', 0, 'percentage'));
  });

  group('Coupon Repository Integration Tests', () {
    final tCoupons = [
      CouponData('SAVE10', 10, 'percentage'),
      CouponData('SAVE50', 50, 'fixed'),
    ];
    final tCoupon = tCoupons[0];

    test('should get available coupons from remote', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getAvailableCoupons(),
      ).thenAnswer((_) async => tCoupons);

      // Act
      final result = await repository.getAvailableCoupons();

      // Assert
      expect(result, Right(tCoupons));
      verify(() => mockRemoteDataSource.getAvailableCoupons()).called(1);
    });

    test('should apply coupon and save to local storage', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.applyCoupon('SAVE10'),
      ).thenAnswer((_) async => tCoupon);
      when(
        () => mockLocalStorage.saveAppliedCoupon(tCoupon),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.applyCoupon('SAVE10');

      // Assert
      expect(result, Right(tCoupon));
      verify(() => mockRemoteDataSource.applyCoupon('SAVE10')).called(1);
      verify(() => mockLocalStorage.saveAppliedCoupon(tCoupon)).called(1);
    });

    test('should remove applied coupon from storage', () async {
      // Arrange
      when(
        () => mockLocalStorage.clearAppliedCoupon(),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.removeCoupon();

      // Assert
      expect(result, const Right(null));
      verify(() => mockLocalStorage.clearAppliedCoupon()).called(1);
    });
  });
}
