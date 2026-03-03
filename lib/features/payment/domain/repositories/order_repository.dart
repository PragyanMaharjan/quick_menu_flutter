import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/payment/data/models/order_hive_model.dart';

abstract class IOrderRepository {
  /// Submit an order - saves locally first, syncs to API if online
  Future<Either<Failure, OrderHiveModel>> submitOrder(
    List<Map<String, dynamic>> items,
    double totalAmount,
  );

  /// Get order history - tries API first, falls back to local
  Future<Either<Failure, List<OrderHiveModel>>> getOrderHistory();

  /// Sync all pending orders to API
  Future<Either<Failure, void>> syncPendingOrders();
}
