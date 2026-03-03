import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = true;
  static const String _ipAddress = '192.168.137.1';
  static const String _apiPath = '/quickScan';
  static const int _port = 5000;

  // Base URLs - Dynamic host selection based on platform
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl$_apiPath';
  static String get mediaServerUrl => serverUrl;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // // ============ Batch Endpoints ============
  // static const String batches = '/batches';
  // static String batchById(String id) => '/batches/$id';

  // // ============ Category Endpoints ============
  // static const String categories = '/categories';
  // static String categoryById(String id) => '/categories/$id';

  // ============ Customer Endpoints ============
  static const String customers = '/customers';
  static const String customerLogin = '/customers/login';
  static const String customerRegister = '/customers/signup';
  // static String customerById(String id) => '/customers/$id';

  // ============ Order Endpoints ============
  static const String submitOrder = '/orders';
  static const String orderHistory = '/orders/history';
  // static String orderById(String id) => '/orders/$id';

  // // ============ Item Endpoints ============
  // static const String items = '/items';
  // static String itemById(String id) => '/items/$id';
  // static String itemClaim(String id) => '/items/$id/claim';

  // ============ Comment Endpoints ============
  // static const String comments = '/comments';
  // static String commentById(String id) => '/comments/$id';
  // static String commentsByItem(String itemId) => '/comments/item/$itemId';
  // static String commentLike(String id) => '/comments/$id/like';
}
