import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quick_menu/core/error/failure.dart';
import 'package:quick_menu/features/auth/domain/entities/auth_entity.dart';
import 'package:quick_menu/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:quick_menu/features/auth/domain/usecases/login_usecase.dart';
import 'package:quick_menu/features/auth/domain/usecases/logout_usecase.dart';
import 'package:quick_menu/features/auth/domain/usecases/register_usecase.dart';
import 'package:quick_menu/features/auth/presentation/state/auth_state.dart';
import 'package:quick_menu/features/auth/presentation/view_model/auth_view_model.dart';

// Mocks
class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecaseImpl {}

void main() {
  late ProviderContainer container;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  final tAuthEntity = AuthEntity(
    userID: '123',
    fullName: 'John Doe',
    email: 'john@test.com',
    phoneNumber: '1234567890',
    photoUrl: 'https://example.com/photo.jpg',
  );

  setUpAll(() {
    registerFallbackValue(
      const RegisterParams(
        fullName: 'Fallback User',
        email: 'fallback@test.com',
        phoneNumber: '0000000000',
        password: 'password123',
      ),
    );
    registerFallbackValue(
      const LoginParams(email: 'fallback@test.com', password: 'password123'),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel - Register', () {
    test(
      'should update state to registered when registration succeeds',
      () async {
        // Arrange
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await container
            .read(authViewModelProvider.notifier)
            .register(
              fullName: 'John Doe',
              email: 'john@test.com',
              phoneNumber: '1234567890',
              password: 'password123',
            );

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.registered);
      },
    );

    test('should update state to error when registration fails', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Email already exists',
        statusCode: 409,
      );
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'John Doe',
            email: 'john@test.com',
            phoneNumber: '1234567890',
            password: 'password123',
          );

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Email already exists');
    });

    test('should set loading state during registration', () async {
      // Arrange
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final registerFuture = container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'John Doe',
            email: 'john@test.com',
            phoneNumber: '1234567890',
            password: 'password123',
          );

      // Check immediate state
      expect(container.read(authViewModelProvider).status, AuthStatus.loading);

      await registerFuture;
    });
  });

  group('AuthViewModel - Login', () {
    test('should update state to authenticated when login succeeds', () async {
      // Arrange
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      // Act
      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'john@test.com', password: 'password123');

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, tAuthEntity);
    });

    test('should update state to error when login fails', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Invalid credentials',
        statusCode: 401,
      );
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'john@test.com', password: 'wrongpassword');

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    });

    test('should store user data after successful login', () async {
      // Arrange
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      // Act
      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'john@test.com', password: 'password123');

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.user?.userID, '123');
      expect(state.user?.email, 'john@test.com');
      expect(state.user?.fullName, 'John Doe');
    });

    test('should set loading state during login', () async {
      // Arrange
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      // Act
      final loginFuture = container
          .read(authViewModelProvider.notifier)
          .login(email: 'john@test.com', password: 'password123');

      expect(container.read(authViewModelProvider).status, AuthStatus.loading);

      await loginFuture;
    });
  });

  group('AuthViewModel - Get Current User', () {
    test(
      'should update state to authenticated when current user exists',
      () async {
        // Arrange
        when(
          () => mockGetCurrentUserUsecase(),
        ).thenAnswer((_) async => Right(tAuthEntity));

        // Act
        await container.read(authViewModelProvider.notifier).getCurrentUser();

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.authenticated);
        expect(state.user, tAuthEntity);
      },
    );

    test(
      'should update state to unauthenticated when no current user exists',
      () async {
        // Arrange
        final tFailure = const ApiFailure(
          message: 'No authentication token found',
          statusCode: 401,
        );
        when(
          () => mockGetCurrentUserUsecase(),
        ).thenAnswer((_) async => Left(tFailure));

        // Act
        await container.read(authViewModelProvider.notifier).getCurrentUser();

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.user, null);
      },
    );

    test('should handle token expiration in get current user', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Token expired',
        statusCode: 401,
      );
      when(
        () => mockGetCurrentUserUsecase(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      await container.read(authViewModelProvider.notifier).getCurrentUser();

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.errorMessage, 'Token expired');
    });

    test('should set loading state during get current user', () async {
      // Arrange
      when(
        () => mockGetCurrentUserUsecase(),
      ).thenAnswer((_) async => Right(tAuthEntity));

      // Act
      final getCurrentUserFuture = container
          .read(authViewModelProvider.notifier)
          .getCurrentUser();

      expect(container.read(authViewModelProvider).status, AuthStatus.loading);

      await getCurrentUserFuture;
    });
  });

  group('AuthViewModel - Logout', () {
    test(
      'should update state to unauthenticated when logout succeeds',
      () async {
        // Arrange - first login
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => Right(tAuthEntity));

        await container
            .read(authViewModelProvider.notifier)
            .login(email: 'john@test.com', password: 'password123');

        // Verify logged in
        expect(
          container.read(authViewModelProvider).status,
          AuthStatus.authenticated,
        );

        // Arrange - logout
        when(
          () => mockLogoutUsecase(),
        ).thenAnswer((_) async => const Right(true));

        // Act
        await container.read(authViewModelProvider.notifier).logout();

        // Assert
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.user, null);
      },
    );

    test('should update state to error when logout fails', () async {
      // Arrange
      final tFailure = const ApiFailure(
        message: 'Logout failed on server',
        statusCode: 500,
      );
      when(() => mockLogoutUsecase()).thenAnswer((_) async => Left(tFailure));

      // Act
      await container.read(authViewModelProvider.notifier).logout();

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Logout failed on server');
    });

    test('should clear user data after successful logout', () async {
      // Arrange - first login
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => Right(tAuthEntity));

      await container
          .read(authViewModelProvider.notifier)
          .login(email: 'john@test.com', password: 'password123');

      // Logout
      when(
        () => mockLogoutUsecase(),
      ).thenAnswer((_) async => const Right(true));

      await container.read(authViewModelProvider.notifier).logout();

      // Assert
      final state = container.read(authViewModelProvider);
      expect(state.user, null);
    });

    test('should set loading state during logout', () async {
      // Arrange
      when(
        () => mockLogoutUsecase(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final logoutFuture = container
          .read(authViewModelProvider.notifier)
          .logout();

      expect(container.read(authViewModelProvider).status, AuthStatus.loading);

      await logoutFuture;
    });
  });
}
