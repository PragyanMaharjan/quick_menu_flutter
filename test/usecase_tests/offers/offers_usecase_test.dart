import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockOffersRepository extends Mock {
  Future<Either<Failure, List<Offer>>> getAvailableOffers();
  Future<Either<Failure, Offer>> getOfferById(String offerId);
  Future<Either<Failure, bool>> applyOffer(String offerId, String userId);
  Future<Either<Failure, List<Offer>>> getUserAppliedOffers(String userId);
}

class Offer {
  final String id;
  final String title;
  final String description;
  final double discount;
  final String type; // percentage or fixed
  final DateTime validUntil;
  final bool isActive;
  Offer(
    this.id,
    this.title,
    this.description,
    this.discount,
    this.type,
    this.validUntil,
    this.isActive,
  );
}

// Use Cases
class GetAvailableOffersUseCase {
  final MockOffersRepository repository;
  GetAvailableOffersUseCase(this.repository);

  Future<Either<Failure, List<Offer>>> call() async {
    return await repository.getAvailableOffers();
  }
}

class GetOfferByIdUseCase {
  final MockOffersRepository repository;
  GetOfferByIdUseCase(this.repository);

  Future<Either<Failure, Offer>> call(String offerId) async {
    return await repository.getOfferById(offerId);
  }
}

class ApplyOfferUseCase {
  final MockOffersRepository repository;
  ApplyOfferUseCase(this.repository);

  Future<Either<Failure, bool>> call(String offerId, String userId) async {
    return await repository.applyOffer(offerId, userId);
  }
}

class GetUserAppliedOffersUseCase {
  final MockOffersRepository repository;
  GetUserAppliedOffersUseCase(this.repository);

  Future<Either<Failure, List<Offer>>> call(String userId) async {
    return await repository.getUserAppliedOffers(userId);
  }
}

void main() {
  late MockOffersRepository mockRepository;
  late GetAvailableOffersUseCase getAvailableOffersUseCase;
  late GetOfferByIdUseCase getOfferByIdUseCase;
  late ApplyOfferUseCase applyOfferUseCase;
  late GetUserAppliedOffersUseCase getUserAppliedOffersUseCase;

  setUp(() {
    mockRepository = MockOffersRepository();
    getAvailableOffersUseCase = GetAvailableOffersUseCase(mockRepository);
    getOfferByIdUseCase = GetOfferByIdUseCase(mockRepository);
    applyOfferUseCase = ApplyOfferUseCase(mockRepository);
    getUserAppliedOffersUseCase = GetUserAppliedOffersUseCase(mockRepository);
  });

  group('Get Available Offers UseCase Tests', () {
    final tOffers = [
      Offer(
        '1',
        'Summer Sale',
        '20% off',
        20.0,
        'percentage',
        DateTime.now().add(const Duration(days: 7)),
        true,
      ),
      Offer(
        '2',
        'New User Offer',
        'Flat ₹100 off',
        100.0,
        'fixed',
        DateTime.now().add(const Duration(days: 30)),
        true,
      ),
    ];

    test('should get available offers successfully', () async {
      // Arrange
      when(
        () => mockRepository.getAvailableOffers(),
      ).thenAnswer((_) async => Right(tOffers));

      // Act
      final result = await getAvailableOffersUseCase();

      // Assert
      expect(result, Right(tOffers));
      verify(() => mockRepository.getAvailableOffers()).called(1);
    });

    test('should return failure when getting offers fails', () async {
      // Arrange
      when(() => mockRepository.getAvailableOffers()).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Failed to load offers')),
      );

      // Act
      final result = await getAvailableOffersUseCase();

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.getAvailableOffers()).called(1);
    });
  });

  group('Get Offer By ID UseCase Tests', () {
    final tOffer = Offer(
      '1',
      'Summer Sale',
      '20% off',
      20.0,
      'percentage',
      DateTime.now().add(const Duration(days: 7)),
      true,
    );

    test('should get offer by ID successfully', () async {
      // Arrange
      when(
        () => mockRepository.getOfferById('1'),
      ).thenAnswer((_) async => Right(tOffer));

      // Act
      final result = await getOfferByIdUseCase('1');

      // Assert
      expect(result, Right(tOffer));
      verify(() => mockRepository.getOfferById('1')).called(1);
    });

    test('should return failure when offer not found', () async {
      // Arrange
      when(() => mockRepository.getOfferById('999')).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Offer not found')),
      );

      // Act
      final result = await getOfferByIdUseCase('999');

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.getOfferById('999')).called(1);
    });
  });

  group('Apply Offer UseCase Tests', () {
    test('should apply offer successfully', () async {
      // Arrange
      when(
        () => mockRepository.applyOffer('offer123', 'user456'),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await applyOfferUseCase('offer123', 'user456');

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.applyOffer('offer123', 'user456')).called(1);
    });

    test('should return failure when offer is expired', () async {
      // Arrange
      when(() => mockRepository.applyOffer('offer123', 'user456')).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Offer expired')),
      );

      // Act
      final result = await applyOfferUseCase('offer123', 'user456');

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.applyOffer('offer123', 'user456')).called(1);
    });

    test('should return failure when offer already used', () async {
      // Arrange
      when(() => mockRepository.applyOffer('offer123', 'user456')).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Offer already used')),
      );

      // Act
      final result = await applyOfferUseCase('offer123', 'user456');

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.applyOffer('offer123', 'user456')).called(1);
    });
  });

  group('Get User Applied Offers UseCase Tests', () {
    final tAppliedOffers = [
      Offer(
        '1',
        'Summer Sale',
        '20% off',
        20.0,
        'percentage',
        DateTime.now().add(const Duration(days: 7)),
        true,
      ),
    ];

    test('should get user applied offers successfully', () async {
      // Arrange
      when(
        () => mockRepository.getUserAppliedOffers('user456'),
      ).thenAnswer((_) async => Right(tAppliedOffers));

      // Act
      final result = await getUserAppliedOffersUseCase('user456');

      // Assert
      expect(result, Right(tAppliedOffers));
      verify(() => mockRepository.getUserAppliedOffers('user456')).called(1);
    });

    test('should return empty list when no offers applied', () async {
      // Arrange
      when(
        () => mockRepository.getUserAppliedOffers('user456'),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await getUserAppliedOffersUseCase('user456');

      // Assert
      expect(result, const Right<Failure, List<Offer>>([]));
      verify(() => mockRepository.getUserAppliedOffers('user456')).called(1);
    });
  });
}
