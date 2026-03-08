import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockOrderRepository extends Mock {
  Future<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, OrderModel>> getOrderById(String id);
}

class OrderModel {
  final String id;
  final double total;
  final String status;

  OrderModel({required this.id, required this.total, required this.status});
}

class GetOrdersUseCase {
  final MockOrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderModel>>> call() {
    return repository.getOrders();
  }
}

class GetOrderByIdUseCase {
  final MockOrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<Either<Failure, OrderModel>> call(String id) {
    return repository.getOrderById(id);
  }
}

void main() {
  late MockOrderRepository mockRepository;
  late GetOrdersUseCase getOrdersUseCase;
  late GetOrderByIdUseCase getOrderByIdUseCase;

  setUp(() {
    mockRepository = MockOrderRepository();
    getOrdersUseCase = GetOrdersUseCase(mockRepository);
    getOrderByIdUseCase = GetOrderByIdUseCase(mockRepository);
  });

  group('Get Orders UseCase Tests', () {
    final tOrders = [
      OrderModel(id: '1', total: 100.0, status: 'completed'),
      OrderModel(id: '2', total: 200.0, status: 'pending'),
    ];

    test('should get list of orders from repository', () async {
      // Arrange
      when(
        () => mockRepository.getOrders(),
      ).thenAnswer((_) async => Right(tOrders));

      // Act
      final result = await getOrdersUseCase();

      // Assert
      expect(result, Right(tOrders));
      verify(() => mockRepository.getOrders()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Network error');
      when(
        () => mockRepository.getOrders(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await getOrdersUseCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getOrders()).called(1);
    });
  });

  group('Get Order By Id UseCase Tests', () {
    final tOrder = OrderModel(id: '1', total: 100.0, status: 'completed');

    test('should get specific order by id', () async {
      // Arrange
      when(
        () => mockRepository.getOrderById('1'),
      ).thenAnswer((_) async => Right(tOrder));

      // Act
      final result = await getOrderByIdUseCase('1');

      // Assert
      expect(result, Right(tOrder));
      verify(() => mockRepository.getOrderById('1')).called(1);
    });

    test('should return failure when order not found', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Order not found', statusCode: 404);
      when(
        () => mockRepository.getOrderById('999'),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await getOrderByIdUseCase('999');

      // Assert
      expect(result, const Left(tFailure));
    });
  });
}
