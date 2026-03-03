import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/api/api_client.dart';
import 'package:quick_menu/core/api/api_endpoint.dart';
import 'package:quick_menu/features/payment/data/datasource/order_datasource.dart';
import 'package:quick_menu/features/payment/data/models/order_hive_model.dart';

final orderRemoteDataSourceProvider = Provider<IOrderRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return OrderRemoteDataSource(apiClient: apiClient);
});

class OrderRemoteDataSource implements IOrderRemoteDataSource {
  final ApiClient _apiClient;

  OrderRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<OrderHiveModel> submitOrder(OrderHiveModel order) async {
    final response = await _apiClient.post(
      ApiEndpoints.submitOrder, // You'll need to add this endpoint
      data: order.toApiJson(),
    );

    // Assuming the API returns the order with updated status/id
    return OrderHiveModel.fromApiJson(response.data);
  }

  @override
  Future<List<OrderHiveModel>> getOrderHistory() async {
    final response = await _apiClient.get(ApiEndpoints.orderHistory);

    final ordersData = response.data as List<dynamic>;
    return ordersData
        .map((orderJson) => OrderHiveModel.fromApiJson(orderJson))
        .toList();
  }
}
