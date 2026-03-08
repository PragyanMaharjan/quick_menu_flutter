import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock classes
class MockAuthUseCase extends Mock {
  Future<Either<Failure, AuthData>> login(String email, String password);
  Future<Either<Failure, bool>> register(RegisterData data);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthData>> getCurrentUser();
}

class AuthData {
  final String id;
  final String email;
  final String name;
  AuthData(this.id, this.email, this.name);
}

class RegisterData {
  final String email;
  final String password;
  final String name;
  RegisterData(this.email, this.password, this.name);
}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthData user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// ViewModel
class AuthViewModel extends StateNotifier<AuthState> {
  final MockAuthUseCase authUseCase;

  AuthViewModel(this.authUseCase) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    final result = await authUseCase.login(email, password);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> register(RegisterData data) async {
    state = AuthLoading();
    final result = await authUseCase.register(data);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = AuthUnauthenticated(),
    );
  }

  Future<void> logout() async {
    state = AuthLoading();
    final result = await authUseCase.logout();
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = AuthUnauthenticated(),
    );
  }

  Future<void> checkAuthStatus() async {
    state = AuthLoading();
    final result = await authUseCase.getCurrentUser();
    result.fold(
      (failure) => state = AuthUnauthenticated(),
      (user) => state = AuthAuthenticated(user),
    );
  }
}

void main() {
  late MockAuthUseCase mockAuthUseCase;
  late AuthViewModel viewModel;

  setUp(() {
    mockAuthUseCase = MockAuthUseCase();
    viewModel = AuthViewModel(mockAuthUseCase);
  });

  group('Auth ViewModel Tests', () {
    final tAuthData = AuthData('1', 'test@test.com', 'Test User');
    final tRegisterData = RegisterData(
      'new@test.com',
      'password123',
      'New User',
    );

    test('should emit initial state', () {
      // Assert
      expect(viewModel.state, isA<AuthInitial>());
    });

    test('should login successfully', () async {
      // Arrange
      when(
        () => mockAuthUseCase.login('test@test.com', 'password123'),
      ).thenAnswer((_) async => Right(tAuthData));

      // Act
      await viewModel.login('test@test.com', 'password123');

      // Assert
      expect(viewModel.state, isA<AuthAuthenticated>());
      final state = viewModel.state as AuthAuthenticated;
      expect(state.user.email, 'test@test.com');
      verify(
        () => mockAuthUseCase.login('test@test.com', 'password123'),
      ).called(1);
    });

    test('should emit error state when login fails', () async {
      // Arrange
      when(() => mockAuthUseCase.login('wrong@test.com', 'wrong')).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Invalid credentials')),
      );

      // Act
      await viewModel.login('wrong@test.com', 'wrong');

      // Assert
      expect(viewModel.state, isA<AuthError>());
      final state = viewModel.state as AuthError;
      expect(state.message, 'Invalid credentials');
      verify(() => mockAuthUseCase.login('wrong@test.com', 'wrong')).called(1);
    });

    test('should register successfully', () async {
      // Arrange
      when(
        () => mockAuthUseCase.register(tRegisterData),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await viewModel.register(tRegisterData);

      // Assert
      expect(viewModel.state, isA<AuthUnauthenticated>());
      verify(() => mockAuthUseCase.register(tRegisterData)).called(1);
    });

    test('should emit error state when registration fails', () async {
      // Arrange
      when(() => mockAuthUseCase.register(tRegisterData)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Email already exists')),
      );

      // Act
      await viewModel.register(tRegisterData);

      // Assert
      expect(viewModel.state, isA<AuthError>());
      verify(() => mockAuthUseCase.register(tRegisterData)).called(1);
    });

    test('should logout successfully', () async {
      // Arrange
      when(
        () => mockAuthUseCase.logout(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await viewModel.logout();

      // Assert
      expect(viewModel.state, isA<AuthUnauthenticated>());
      verify(() => mockAuthUseCase.logout()).called(1);
    });

    test('should check auth status and authenticate user', () async {
      // Arrange
      when(
        () => mockAuthUseCase.getCurrentUser(),
      ).thenAnswer((_) async => Right(tAuthData));

      // Act
      await viewModel.checkAuthStatus();

      // Assert
      expect(viewModel.state, isA<AuthAuthenticated>());
      verify(() => mockAuthUseCase.getCurrentUser()).called(1);
    });

    test('should check auth status and set unauthenticated', () async {
      // Arrange
      when(() => mockAuthUseCase.getCurrentUser()).thenAnswer(
        (_) async => const Left(LocalDatabaseFailure(message: 'No user')),
      );

      // Act
      await viewModel.checkAuthStatus();

      // Assert
      expect(viewModel.state, isA<AuthUnauthenticated>());
      verify(() => mockAuthUseCase.getCurrentUser()).called(1);
    });
  });
}
