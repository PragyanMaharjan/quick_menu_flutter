import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_menu/features/payment/data/datasource/order_datasource.dart';
import 'package:quick_menu/features/payment/data/models/order_hive_model.dart';

final orderLocalDataSourceProvider = Provider<IOrderLocalDataSource>((ref) {
  return OrderLocalDataSource();
});

class OrderLocalDataSource implements IOrderLocalDataSource {
  Box<OrderHiveModel> get _orderBox => Hive.box<OrderHiveModel>('orders');

  @override
  Future<OrderHiveModel> saveOrder(OrderHiveModel order) async {
    await _orderBox.put(order.orderId, order);
    return order;
  }

  @override
  Future<List<OrderHiveModel>> getUnsyncedOrders() async {
    final allOrders = _orderBox.values.toList();
    return allOrders.where((order) => !order.isSynced).toList();
  }

  @override
  Future<void> markOrderAsSynced(String orderId) async {
    final order = _orderBox.get(orderId);
    if (order != null) {
      final syncedOrder = OrderHiveModel(
        orderId: order.orderId,
        items: order.items,
        totalAmount: order.totalAmount,
        status: order.status,
        orderDate: order.orderDate,
        isSynced: true,
      );
      await _orderBox.put(orderId, syncedOrder);
    }
  }

  @override
  Future<List<OrderHiveModel>> getAllOrders() async {
    return _orderBox.values.toList();
  }
}
