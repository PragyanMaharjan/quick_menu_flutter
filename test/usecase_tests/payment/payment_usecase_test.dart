import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockPaymentRepository extends Mock {
  Future<Either<Failure, PaymentResult>> processPayment(PaymentRequest request);
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();
}

class PaymentRequest {
  final double amount;
  final String method;

  PaymentRequest({required this.amount, required this.method});
}

class PaymentResult {
  final String transactionId;
  final bool success;

  PaymentResult({required this.transactionId, required this.success});
}

class PaymentMethod {
  final String id;
  final String name;

  PaymentMethod({required this.id, required this.name});
}

class ProcessPaymentUseCase {
  final MockPaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<Either<Failure, PaymentResult>> call(PaymentRequest request) {
    return repository.processPayment(request);
  }
}

class GetPaymentMethodsUseCase {
  final MockPaymentRepository repository;

  GetPaymentMethodsUseCase(this.repository);

  Future<Either<Failure, List<PaymentMethod>>> call() {
    return repository.getPaymentMethods();
  }
}

void main() {
  late MockPaymentRepository mockRepository;
  late ProcessPaymentUseCase processPaymentUseCase;
  late GetPaymentMethodsUseCase getPaymentMethodsUseCase;

  setUp(() {
    mockRepository = MockPaymentRepository();
    processPaymentUseCase = ProcessPaymentUseCase(mockRepository);
    getPaymentMethodsUseCase = GetPaymentMethodsUseCase(mockRepository);
  });

  group('Process Payment UseCase Tests', () {
    final tPaymentRequest = PaymentRequest(amount: 1000.0, method: 'card');
    final tPaymentResult = PaymentResult(
      transactionId: 'TXN123',
      success: true,
    );

    test('should process payment successfully', () async {
      // Arrange
      when(
        () => mockRepository.processPayment(tPaymentRequest),
      ).thenAnswer((_) async => Right(tPaymentResult));

      // Act
      final result = await processPaymentUseCase(tPaymentRequest);

      // Assert
      expect(result, Right(tPaymentResult));
      verify(() => mockRepository.processPayment(tPaymentRequest)).called(1);
    });

    test('should return failure when payment processing fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Payment failed');
      when(
        () => mockRepository.processPayment(tPaymentRequest),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await processPaymentUseCase(tPaymentRequest);

      // Assert
      expect(result, const Left(tFailure));
    });
  });

  group('Get Payment Methods UseCase Tests', () {
    final tPaymentMethods = [
      PaymentMethod(id: '1', name: 'Credit Card'),
      PaymentMethod(id: '2', name: 'Cash'),
    ];

    test('should get list of available payment methods', () async {
      // Arrange
      when(
        () => mockRepository.getPaymentMethods(),
      ).thenAnswer((_) async => Right(tPaymentMethods));

      // Act
      final result = await getPaymentMethodsUseCase();

      // Assert
      expect(result, Right(tPaymentMethods));
      verify(() => mockRepository.getPaymentMethods()).called(1);
    });
  });
}
