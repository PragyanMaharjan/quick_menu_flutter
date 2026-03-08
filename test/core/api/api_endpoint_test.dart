import 'package:flutter_test/flutter_test.dart';
import 'package:quick_menu/core/api/api_endpoint.dart';

void main() {
  group('ApiEndpoints', () {
    test('should have valid base URL', () {
      expect(ApiEndpoints.baseUrl, contains('/quickScan'));
    });

    test('should have connection timeout of 15 seconds', () {
      expect(
        ApiEndpoints.connectionTimeout,
        equals(const Duration(seconds: 15)),
      );
    });

    test('should have receive timeout of 20 seconds', () {
      expect(ApiEndpoints.receiveTimeout, equals(const Duration(seconds: 20)));
    });

    test('should have customers endpoint', () {
      expect(ApiEndpoints.customers, equals('/customers'));
    });

    test('should have customer login endpoint', () {
      expect(ApiEndpoints.customerLogin, equals('/customers/login'));
    });

    test('should have customer register endpoint', () {
      expect(ApiEndpoints.customerRegister, equals('/customers/signup'));
    });

    test('should construct full URL for login endpoint', () {
      final fullUrl = '${ApiEndpoints.baseUrl}${ApiEndpoints.customerLogin}';
      expect(fullUrl, contains('/quickScan/customers/login'));
    });

    test('should construct full URL for register endpoint', () {
      final fullUrl = '${ApiEndpoints.baseUrl}${ApiEndpoints.customerRegister}';
      expect(fullUrl, contains('/quickScan/customers/signup'));
    });

    test('should construct full URL for customers endpoint', () {
      final fullUrl = '${ApiEndpoints.baseUrl}${ApiEndpoints.customers}';
      expect(fullUrl, contains('/quickScan/customers'));
    });

    test('should have reasonable timeout durations', () {
      expect(ApiEndpoints.connectionTimeout.inSeconds, greaterThan(0));
      expect(ApiEndpoints.receiveTimeout.inSeconds, greaterThan(0));
    });
  });
}
