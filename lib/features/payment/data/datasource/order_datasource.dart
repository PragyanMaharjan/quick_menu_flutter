import 'package:quick_menu/features/payment/data/models/order_hive_model.dart';

abstract class IOrderLocalDataSource {
  Future<OrderHiveModel> saveOrder(OrderHiveModel order);
  Future<List<OrderHiveModel>> getUnsyncedOrders();
  Future<void> markOrderAsSynced(String orderId);
  Future<List<OrderHiveModel>> getAllOrders();
}

abstract class IOrderRemoteDataSource {
  Future<OrderHiveModel> submitOrder(OrderHiveModel order);
  Future<List<OrderHiveModel>> getOrderHistory();
}
