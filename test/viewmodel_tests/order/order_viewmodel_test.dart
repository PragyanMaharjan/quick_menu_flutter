import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock UseCase
class MockGetOrdersUseCase extends Mock {
  Future<Either<Failure, List<Order>>> call();
}

class Order {
  final String id;
  final double total;
  Order(this.id, this.total);
}

// State classes
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Order> orders;
  OrderLoaded(this.orders);
}

class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}

// ViewModel
class OrderViewModel extends StateNotifier<OrderState> {
  final MockGetOrdersUseCase getOrdersUseCase;

  OrderViewModel(this.getOrdersUseCase) : super(OrderInitial());

  Future<void> loadOrders() async {
    state = OrderLoading();
    final result = await getOrdersUseCase();
    result.fold(
      (failure) => state = OrderError(failure.message),
      (orders) => state = OrderLoaded(orders),
    );
  }
}

void main() {
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late OrderViewModel viewModel;

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    viewModel = OrderViewModel(mockGetOrdersUseCase);
  });

  group('Order ViewModel Tests', () {
    test('initial state should be OrderInitial', () {
      expect(viewModel.state, isA<OrderInitial>());
    });

    test(
      'should emit OrderLoading then OrderLoaded when orders fetched successfully',
      () async {
        // Arrange
        final tOrders = [Order('1', 100.0), Order('2', 200.0)];
        when(
          () => mockGetOrdersUseCase(),
        ).thenAnswer((_) async => Right(tOrders));

        // Act
        await viewModel.loadOrders();

        // Assert
        expect(viewModel.state, isA<OrderLoaded>());
        expect((viewModel.state as OrderLoaded).orders, tOrders);
        verify(() => mockGetOrdersUseCase()).called(1);
      },
    );

    test('should emit OrderError when fetching orders fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Network error');
      when(
        () => mockGetOrdersUseCase(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      await viewModel.loadOrders();

      // Assert
      expect(viewModel.state, isA<OrderError>());
      expect((viewModel.state as OrderError).message, 'Network error');
    });
  });
}
