import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/core/services/connecitivity/network_info.dart';
import 'package:quick_menu/features/payment/data/datasource/local/order_local_datasource.dart';
import 'package:quick_menu/features/payment/data/datasource/remote/order_remote_datasource.dart';
import 'package:quick_menu/features/payment/data/datasource/order_datasource.dart';
import 'package:quick_menu/features/payment/data/models/order_hive_model.dart';
import 'package:quick_menu/features/payment/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<IOrderRepository>((ref) {
  final localDataSource = ref.read(orderLocalDataSourceProvider);
  final remoteDataSource = ref.read(orderRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return OrderRepository(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class OrderRepository implements IOrderRepository {
  final IOrderLocalDataSource _localDataSource;
  final IOrderRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  OrderRepository({
    required IOrderLocalDataSource localDataSource,
    required IOrderRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, OrderHiveModel>> submitOrder(
    List<Map<String, dynamic>> items,
    double totalAmount, {
    String? tableId,
    String? orderType,
  }) async {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final order = OrderHiveModel(
      orderId: orderId,
      items: items,
      totalAmount: totalAmount,
      status: 'pending',
      orderDate: DateTime.now(),
      isSynced: false,
      tableId: tableId,
      orderType: orderType,
    );

    // Always save locally first
    await _localDataSource.saveOrder(order);

    // Try to sync if online
    if (await _networkInfo.isConnected) {
      try {
        final syncedOrder = await _remoteDataSource.submitOrder(order);
        await _localDataSource.markOrderAsSynced(orderId);
        return Right(syncedOrder);
      } catch (e) {
        // Sync failed, but order is saved locally
        return Right(order); // Return local order, marked as unsynced
      }
    } else {
      // Offline - return local order
      return Right(order);
    }
  }

  @override
  Future<Either<Failure, List<OrderHiveModel>>> getOrderHistory() async {
    try {
      if (await _networkInfo.isConnected) {
        // Online - get from API and update local
        final remoteOrders = await _remoteDataSource.getOrderHistory();

        // Update local storage with remote data
        for (final order in remoteOrders) {
          await _localDataSource.saveOrder(order);
        }

        return Right(remoteOrders);
      } else {
        // Offline - get from local storage
        final localOrders = await _localDataSource.getAllOrders();
        return Right(localOrders);
      }
    } catch (e) {
      // If API fails, fall back to local
      try {
        final localOrders = await _localDataSource.getAllOrders();
        return Right(localOrders);
      } catch (localError) {
        return Left(LocalDatabaseFailure(message: localError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> syncPendingOrders() async {
    if (!(await _networkInfo.isConnected)) {
      return Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final unsyncedOrders = await _localDataSource.getUnsyncedOrders();

      for (final order in unsyncedOrders) {
        try {
          await _remoteDataSource.submitOrder(order);
          await _localDataSource.markOrderAsSynced(order.orderId);
        } catch (e) {
          // Continue with other orders even if one fails
          continue;
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: 'Failed to sync orders: ${e.toString()}'),
      );
    }
  }
}
