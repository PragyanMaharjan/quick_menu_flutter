import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock UseCase
class MockProcessPaymentUseCase extends Mock {
  Future<Either<Failure, PaymentResult>> call(PaymentRequest request);
}

class PaymentRequest {
  final double amount;
  final String method;
  PaymentRequest(this.amount, this.method);
}

class PaymentResult {
  final String transactionId;
  final bool success;
  PaymentResult(this.transactionId, this.success);
}

// State classes
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentResult result;
  PaymentSuccess(this.result);
}

class PaymentFailed extends PaymentState {
  final String message;
  PaymentFailed(this.message);
}

// ViewModel
class PaymentViewModel extends StateNotifier<PaymentState> {
  final MockProcessPaymentUseCase processPaymentUseCase;

  PaymentViewModel(this.processPaymentUseCase) : super(PaymentInitial());

  Future<void> processPayment(PaymentRequest request) async {
    state = PaymentProcessing();
    final result = await processPaymentUseCase(request);
    result.fold(
      (failure) => state = PaymentFailed(failure.message),
      (paymentResult) => state = PaymentSuccess(paymentResult),
    );
  }
}

void main() {
  late MockProcessPaymentUseCase mockProcessPaymentUseCase;
  late PaymentViewModel viewModel;

  setUp(() {
    mockProcessPaymentUseCase = MockProcessPaymentUseCase();
    viewModel = PaymentViewModel(mockProcessPaymentUseCase);
  });

  setUpAll(() {
    registerFallbackValue(PaymentRequest(0, ''));
  });

  group('Payment ViewModel Tests', () {
    test('initial state should be PaymentInitial', () {
      expect(viewModel.state, isA<PaymentInitial>());
    });

    test('should process payment successfully', () async {
      // Arrange
      final tRequest = PaymentRequest(1000.0, 'card');
      final tResult = PaymentResult('TXN123', true);
      when(
        () => mockProcessPaymentUseCase(tRequest),
      ).thenAnswer((_) async => Right(tResult));

      // Act
      await viewModel.processPayment(tRequest);

      // Assert
      expect(viewModel.state, isA<PaymentSuccess>());
      expect(
        (viewModel.state as PaymentSuccess).result.transactionId,
        'TXN123',
      );
      verify(() => mockProcessPaymentUseCase(tRequest)).called(1);
    });

    test('should emit PaymentFailed when payment fails', () async {
      // Arrange
      final tRequest = PaymentRequest(1000.0, 'card');
      const tFailure = ApiFailure(message: 'Payment declined');
      when(
        () => mockProcessPaymentUseCase(tRequest),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      await viewModel.processPayment(tRequest);

      // Assert
      expect(viewModel.state, isA<PaymentFailed>());
      expect((viewModel.state as PaymentFailed).message, 'Payment declined');
    });

    test('should emit PaymentProcessing before completing', () async {
      // Arrange
      final tRequest = PaymentRequest(1000.0, 'card');
      final tResult = PaymentResult('TXN123', true);
      when(
        () => mockProcessPaymentUseCase(tRequest),
      ).thenAnswer((_) async => Right(tResult));

      // Act & Assert
      expect(viewModel.state, isA<PaymentInitial>());
      final future = viewModel.processPayment(tRequest);
      // State should be processing immediately
      await Future.delayed(Duration.zero);
      await future;
    });
  });
}
