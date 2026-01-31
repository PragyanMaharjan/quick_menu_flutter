import 'package:flutter_test/flutter_test.dart';
import 'package:quick_menu/core/error/failure.dart';

void main() {
  group('Failure', () {
    group('ApiFailure', () {
      test('should create ApiFailure with message only', () {
        // Arrange
        const tMessage = 'API request failed';
        const failure = ApiFailure(message: tMessage);

        // Assert
        expect(failure.message, equals(tMessage));
        expect(failure.statusCode, null);
      });

      test('should create ApiFailure with message and status code', () {
        // Arrange
        const tMessage = 'Unauthorized';
        const tStatusCode = 401;
        const failure = ApiFailure(message: tMessage, statusCode: tStatusCode);

        // Assert
        expect(failure.message, equals(tMessage));
        expect(failure.statusCode, equals(tStatusCode));
      });

      test('should support equality comparison', () {
        // Arrange
        const failure1 = ApiFailure(message: 'Error', statusCode: 400);
        const failure2 = ApiFailure(message: 'Error', statusCode: 400);

        // Assert
        expect(failure1, equals(failure2));
      });

      test('should have different equality for different messages', () {
        // Arrange
        const failure1 = ApiFailure(message: 'Error 1', statusCode: 400);
        const failure2 = ApiFailure(message: 'Error 2', statusCode: 400);

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('should support props comparison', () {
        // Arrange
        const failure = ApiFailure(message: 'Error', statusCode: 400);

        // Assert
        expect(failure.props, ['Error']);
      });

      test('should have default message when not provided', () {
        // Arrange
        const failure = ApiFailure();

        // Assert
        expect(failure.message, equals('API Failure'));
        expect(failure.statusCode, null);
      });
    });

    group('LocalDatabaseFailure', () {
      test('should create LocalDatabaseFailure with default message', () {
        // Arrange
        const failure = LocalDatabaseFailure();

        // Assert
        expect(failure.message, equals('Local Database Failure'));
      });

      test('should create LocalDatabaseFailure with custom message', () {
        // Arrange
        const tMessage = 'Database connection error';
        const failure = LocalDatabaseFailure(message: tMessage);

        // Assert
        expect(failure.message, equals(tMessage));
      });

      test('should support equality comparison', () {
        // Arrange
        const failure1 = LocalDatabaseFailure(message: 'Error');
        const failure2 = LocalDatabaseFailure(message: 'Error');

        // Assert
        expect(failure1, equals(failure2));
      });

      test('should have different equality for different messages', () {
        // Arrange
        const failure1 = LocalDatabaseFailure(message: 'Error 1');
        const failure2 = LocalDatabaseFailure(message: 'Error 2');

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('should support props comparison', () {
        // Arrange
        const failure = LocalDatabaseFailure(message: 'DB Error');

        // Assert
        expect(failure.props, ['DB Error']);
      });
    });

    group('Failure comparison', () {
      test('should not equal different failure types with same message', () {
        // Arrange
        const apiFailure = ApiFailure(message: 'Error');
        const dbFailure = LocalDatabaseFailure(message: 'Error');

        // Assert
        expect(apiFailure, isNot(equals(dbFailure)));
      });

      test('should have consistent message property', () {
        // Arrange
        const tMessage = 'Test Error';
        const failure = ApiFailure(message: tMessage);

        // Assert
        expect(failure.message, equals(tMessage));
        expect(failure.message, isNotEmpty);
      });
    });
  });
}
