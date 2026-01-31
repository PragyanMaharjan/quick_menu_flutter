import 'package:flutter_test/flutter_test.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity', () {
    const tAuthEntity = AuthEntity(
      userID: '123',
      fullName: 'John Doe',
      email: 'john@gmail.com',
      phoneNumber: '9876543210',
      password: 'password123',
      photoUrl: 'https://example.com/photo.jpg',
    );

    test('should create AuthEntity with all properties', () {
      // Assert
      expect(tAuthEntity.userID, '123');
      expect(tAuthEntity.fullName, 'John Doe');
      expect(tAuthEntity.email, 'john@gmail.com');
      expect(tAuthEntity.phoneNumber, '9876543210');
      expect(tAuthEntity.password, 'password123');
      expect(tAuthEntity.photoUrl, 'https://example.com/photo.jpg');
    });

    test('should support equality comparison', () {
      // Arrange
      const sameAuthEntity = AuthEntity(
        userID: '123',
        fullName: 'John Doe',
        email: 'john@gmail.com',
        phoneNumber: '9876543210',
        password: 'password123',
        photoUrl: 'https://example.com/photo.jpg',
      );

      // Assert
      expect(tAuthEntity, equals(sameAuthEntity));
    });

    test('should have different equality for different entities', () {
      // Arrange
      const differentAuthEntity = AuthEntity(
        userID: '456',
        fullName: 'Jane Doe',
        email: 'jane@gmail.com',
        phoneNumber: '1234567890',
        password: 'password456',
        photoUrl: 'https://example.com/photo2.jpg',
      );

      // Assert
      expect(tAuthEntity, isNot(equals(differentAuthEntity)));
    });

    test('should support props comparison', () {
      // Assert
      expect(tAuthEntity.props, [
        '123',
        'John Doe',
        'john@gmail.com',
        '9876543210',
        'https://example.com/photo.jpg',
      ]);
    });

    test('should create AuthEntity with nullable fields', () {
      // Arrange
      const minimalAuthEntity = AuthEntity(
        fullName: 'John Doe',
        email: 'john@gmail.com',
      );

      // Assert
      expect(minimalAuthEntity.userID, null);
      expect(minimalAuthEntity.phoneNumber, null);
      expect(minimalAuthEntity.password, null);
      expect(minimalAuthEntity.photoUrl, null);
      expect(minimalAuthEntity.fullName, 'John Doe');
      expect(minimalAuthEntity.email, 'john@gmail.com');
    });

    test('should maintain hashCode consistency for equal entities', () {
      // Arrange
      const sameAuthEntity = AuthEntity(
        userID: '123',
        fullName: 'John Doe',
        email: 'john@gmail.com',
        phoneNumber: '9876543210',
        password: 'password123',
        photoUrl: 'https://example.com/photo.jpg',
      );

      // Assert
      expect(tAuthEntity.hashCode, equals(sameAuthEntity.hashCode));
    });
  });
}
