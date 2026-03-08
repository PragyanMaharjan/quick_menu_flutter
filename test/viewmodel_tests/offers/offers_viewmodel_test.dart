import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockOffersUseCase extends Mock {
  Future<Either<Failure, List<Offer>>> getAvailableOffers();
  Future<Either<Failure, bool>> applyOffer(String offerId, String userId);
  Future<Either<Failure, List<Offer>>> getUserAppliedOffers(String userId);
}

class Offer {
  final String id;
  final String title;
  final double discount;
  Offer(this.id, this.title, this.discount);
}

// States
abstract class OffersState {}

class OffersInitial extends OffersState {}

class OffersLoading extends OffersState {}

class OffersLoaded extends OffersState {
  final List<Offer> offers;
  OffersLoaded(this.offers);
}

class OfferApplied extends OffersState {
  final String offerId;
  OfferApplied(this.offerId);
}

class OffersError extends OffersState {
  final String message;
  OffersError(this.message);
}

// ViewModel
class OffersViewModel extends StateNotifier<OffersState> {
  final MockOffersUseCase offersUseCase;

  OffersViewModel(this.offersUseCase) : super(OffersInitial());

  Future<void> loadOffers() async {
    state = OffersLoading();
    final result = await offersUseCase.getAvailableOffers();
    result.fold(
      (failure) => state = OffersError(failure.message),
      (offers) => state = OffersLoaded(offers),
    );
  }

  Future<void> applyOffer(String offerId, String userId) async {
    state = OffersLoading();
    final result = await offersUseCase.applyOffer(offerId, userId);
    result.fold(
      (failure) => state = OffersError(failure.message),
      (success) => state = OfferApplied(offerId),
    );
  }

  Future<void> loadUserAppliedOffers(String userId) async {
    state = OffersLoading();
    final result = await offersUseCase.getUserAppliedOffers(userId);
    result.fold(
      (failure) => state = OffersError(failure.message),
      (offers) => state = OffersLoaded(offers),
    );
  }
}

void main() {
  late MockOffersUseCase mockOffersUseCase;
  late OffersViewModel viewModel;

  setUp(() {
    mockOffersUseCase = MockOffersUseCase();
    viewModel = OffersViewModel(mockOffersUseCase);
  });

  group('Offers ViewModel Tests', () {
    final tOffers = [
      Offer('1', 'Summer Sale', 20.0),
      Offer('2', 'New User Offer', 100.0),
    ];

    test('should emit initial state', () {
      // Assert
      expect(viewModel.state, isA<OffersInitial>());
    });

    test('should load offers successfully', () async {
      // Arrange
      when(
        () => mockOffersUseCase.getAvailableOffers(),
      ).thenAnswer((_) async => Right(tOffers));

      // Act
      await viewModel.loadOffers();

      // Assert
      expect(viewModel.state, isA<OffersLoaded>());
      final state = viewModel.state as OffersLoaded;
      expect(state.offers.length, 2);
      verify(() => mockOffersUseCase.getAvailableOffers()).called(1);
    });

    test('should emit error state when loading offers fails', () async {
      // Arrange
      when(() => mockOffersUseCase.getAvailableOffers()).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Failed to load')),
      );

      // Act
      await viewModel.loadOffers();

      // Assert
      expect(viewModel.state, isA<OffersError>());
      verify(() => mockOffersUseCase.getAvailableOffers()).called(1);
    });

    test('should apply offer successfully', () async {
      // Arrange
      when(
        () => mockOffersUseCase.applyOffer('offer123', 'user456'),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await viewModel.applyOffer('offer123', 'user456');

      // Assert
      expect(viewModel.state, isA<OfferApplied>());
      final state = viewModel.state as OfferApplied;
      expect(state.offerId, 'offer123');
      verify(
        () => mockOffersUseCase.applyOffer('offer123', 'user456'),
      ).called(1);
    });

    test('should emit error when applying offer fails', () async {
      // Arrange
      when(
        () => mockOffersUseCase.applyOffer('offer123', 'user456'),
      ).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Offer expired')),
      );

      // Act
      await viewModel.applyOffer('offer123', 'user456');

      // Assert
      expect(viewModel.state, isA<OffersError>());
      verify(
        () => mockOffersUseCase.applyOffer('offer123', 'user456'),
      ).called(1);
    });

    test('should load user applied offers successfully', () async {
      // Arrange
      when(
        () => mockOffersUseCase.getUserAppliedOffers('user456'),
      ).thenAnswer((_) async => Right([tOffers[0]]));

      // Act
      await viewModel.loadUserAppliedOffers('user456');

      // Assert
      expect(viewModel.state, isA<OffersLoaded>());
      final state = viewModel.state as OffersLoaded;
      expect(state.offers.length, 1);
      verify(() => mockOffersUseCase.getUserAppliedOffers('user456')).called(1);
    });
  });
}
