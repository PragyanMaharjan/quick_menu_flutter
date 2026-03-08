import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockPaymentGateway extends Mock {
  Future<PaymentResponse> processPayment(PaymentData data);
}

class MockPaymentLocalStorage extends Mock {
  Future<void> saveTransaction(TransactionRecord record);
  Future<List<TransactionRecord>> getTransactionHistory();
}

class PaymentData {
  final double amount;
  final String method;
  PaymentData(this.amount, this.method);
}

class PaymentResponse {
  final String transactionId;
  final bool success;
  PaymentResponse(this.transactionId, this.success);
}

class TransactionRecord {
  final String id;
  final double amount;
  final DateTime date;
  TransactionRecord(this.id, this.amount, this.date);
}

// Repository
class PaymentRepository {
  final MockPaymentGateway paymentGateway;
  final MockPaymentLocalStorage localStorage;

  PaymentRepository(this.paymentGateway, this.localStorage);

  Future<Either<Failure, PaymentResponse>> processPayment(
    PaymentData data,
  ) async {
    try {
      final response = await paymentGateway.processPayment(data);
      if (response.success) {
        final record = TransactionRecord(
          response.transactionId,
          data.amount,
          DateTime.now(),
        );
        await localStorage.saveTransaction(record);
      }
      return Right(response);
    } catch (e) {
      return const Left(ApiFailure(message: 'Payment processing failed'));
    }
  }

  Future<Either<Failure, List<TransactionRecord>>>
  getTransactionHistory() async {
    try {
      final history = await localStorage.getTransactionHistory();
      return Right(history);
    } catch (e) {
      return const Left(LocalDatabaseFailure(message: 'Failed to get history'));
    }
  }
}

void main() {
  late MockPaymentGateway mockPaymentGateway;
  late MockPaymentLocalStorage mockLocalStorage;
  late PaymentRepository repository;

  setUp(() {
    mockPaymentGateway = MockPaymentGateway();
    mockLocalStorage = MockPaymentLocalStorage();
    repository = PaymentRepository(mockPaymentGateway, mockLocalStorage);
  });

  setUpAll(() {
    registerFallbackValue(PaymentData(0, ''));
    registerFallbackValue(TransactionRecord('1', 0, DateTime.now()));
  });

  group('Payment Repository Integration Tests', () {
    final tPaymentData = PaymentData(1000.0, 'card');
    final tPaymentResponse = PaymentResponse('TXN123', true);

    test('should process payment and save transaction record', () async {
      // Arrange
      when(
        () => mockPaymentGateway.processPayment(tPaymentData),
      ).thenAnswer((_) async => tPaymentResponse);
      when(
        () => mockLocalStorage.saveTransaction(any()),
      ).thenAnswer((_) async => {});

      // Act
      final result = await repository.processPayment(tPaymentData);

      // Assert
      expect(result, Right(tPaymentResponse));
      verify(() => mockPaymentGateway.processPayment(tPaymentData)).called(1);
      verify(() => mockLocalStorage.saveTransaction(any())).called(1);
    });

    test('should get transaction history from storage', () async {
      // Arrange
      final tHistory = [
        TransactionRecord('TXN1', 100.0, DateTime.now()),
        TransactionRecord('TXN2', 200.0, DateTime.now()),
      ];
      when(
        () => mockLocalStorage.getTransactionHistory(),
      ).thenAnswer((_) async => tHistory);

      // Act
      final result = await repository.getTransactionHistory();

      // Assert
      expect(result, Right(tHistory));
      verify(() => mockLocalStorage.getTransactionHistory()).called(1);
    });

    test('should return failure when payment gateway fails', () async {
      // Arrange
      when(
        () => mockPaymentGateway.processPayment(tPaymentData),
      ).thenThrow(Exception('Gateway error'));

      // Act
      final result = await repository.processPayment(tPaymentData);

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
