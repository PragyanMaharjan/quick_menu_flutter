import 'package:flutter_test/flutter_test.dart';
import 'package:quick_menu/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return null for valid Gmail email', () {
        final result = Validators.validateEmail('test@gmail.com');
        expect(result, null);
      });

      test('should return error for email without @', () {
        final result = Validators.validateEmail('testgmail.com');
        expect(result, contains('@'));
      });

      test('should return error for non-Gmail email', () {
        final result = Validators.validateEmail('test@yahoo.com');
        expect(result, contains('@gmail.com'));
      });

      test('should return error for empty email', () {
        final result = Validators.validateEmail('');
        expect(result, contains('required'));
      });

      test('should return error for null email', () {
        final result = Validators.validateEmail(null);
        expect(result, contains('required'));
      });
    });

    group('validatePhoneNumber', () {
      test('should return null for valid 10-digit phone number', () {
        final result = Validators.validatePhoneNumber('9876543210');
        expect(result, null);
      });

      test('should return null for phone number with formatting', () {
        final result = Validators.validatePhoneNumber('987-654-3210');
        expect(result, null);
      });

      test('should return error for phone number with less than 10 digits', () {
        final result = Validators.validatePhoneNumber('987654321');
        expect(result, contains('10 digits'));
      });

      test('should return error for phone number with more than 10 digits', () {
        final result = Validators.validatePhoneNumber('98765432101');
        expect(result, contains('10 digits'));
      });

      test('should return error for empty phone number', () {
        final result = Validators.validatePhoneNumber('');
        expect(result, contains('required'));
      });

      test('should return error for null phone number', () {
        final result = Validators.validatePhoneNumber(null);
        expect(result, contains('required'));
      });
    });

    group('validatePassword', () {
      test('should return null for password with 6 or more characters', () {
        final result = Validators.validatePassword('password123');
        expect(result, null);
      });

      test('should return null for password with exactly 6 characters', () {
        final result = Validators.validatePassword('pass12');
        expect(result, null);
      });

      test('should return error for password with less than 6 characters', () {
        final result = Validators.validatePassword('pass1');
        expect(result, contains('6 characters'));
      });

      test('should return error for empty password', () {
        final result = Validators.validatePassword('');
        expect(result, contains('required'));
      });

      test('should return error for null password', () {
        final result = Validators.validatePassword(null);
        expect(result, contains('required'));
      });
    });

    group('validateName', () {
      test('should return null for valid name with 2 or more characters', () {
        final result = Validators.validateName('John Doe');
        expect(result, null);
      });

      test('should return null for name with exactly 2 characters', () {
        final result = Validators.validateName('Jo');
        expect(result, null);
      });

      test('should return error for name with less than 2 characters', () {
        final result = Validators.validateName('A');
        expect(result, contains('2 characters'));
      });

      test('should return error for empty name', () {
        final result = Validators.validateName('');
        expect(result, contains('required'));
      });

      test('should return error for null name', () {
        final result = Validators.validateName(null);
        expect(result, contains('required'));
      });
    });
  });
}
