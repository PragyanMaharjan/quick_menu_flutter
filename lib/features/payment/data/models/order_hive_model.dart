import 'package:hive/hive.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: 2) // Use a different typeId than auth (which is 0)
class OrderHiveModel {
  @HiveField(0)
  final String orderId;

  @HiveField(1)
  final List<Map<String, dynamic>> items; // Store items as JSON

  @HiveField(2)
  final double totalAmount;

  @HiveField(3)
  final String status;

  @HiveField(4)
  final DateTime orderDate;

  @HiveField(5)
  final bool isSynced;

  @HiveField(6)
  final String? tableId;

  @HiveField(7)
  final String? orderType;

  OrderHiveModel({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.isSynced = false,
    this.tableId,
    this.orderType,
  });

  // Convert to API format
  Map<String, dynamic> toApiJson() {
    return {
      'orderId': orderId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      if (tableId != null) 'tableId': tableId,
      if (orderType != null) 'orderType': orderType,
    };
  }

  // Create from API response
  factory OrderHiveModel.fromApiJson(Map<String, dynamic> json) {
    return OrderHiveModel(
      orderId: json['orderId'] ?? json['id'],
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      isSynced: true,
      tableId: json['tableId'],
      orderType: json['orderType'],
    );
  }
}
