import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_usecase.dart';
import '../state/auth_state.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  @override
  AuthState build() {
    // 👇 these are set from provider (see provider code below)
    throw UnimplementedError(
      "AuthViewModel must be created using authViewModelProvider",
    );
  }

  // ✅ initializer called from provider
  void init({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) {
    _loginUseCase = loginUseCase;
    _registerUseCase = registerUseCase;
    _logoutUseCase = logoutUseCase;
    _getCurrentUserUseCase = getCurrentUserUseCase;

    state = const AuthState.initial();
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    final result = await _getCurrentUserUseCase();

    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
          (user) {
        state = state.copyWith(isLoading: false, user: user);
      },
    );
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    final result = await _loginUseCase(LoginParams(email: email, password: password));

    return result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
          (_) async {
        final current = await _getCurrentUserUseCase();
        current.fold(
              (_) {
            state = state.copyWith(isLoading: false, successMessage: "Login successful");
          },
              (user) {
            state = state.copyWith(
              isLoading: false,
              user: user,
              successMessage: "Login successful",
            );
          },
        );
        return true;
      },
    );
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    final result = await _registerUseCase(
      RegisterParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      ),
    );

    return result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
          (_) async {
        final current = await _getCurrentUserUseCase();
        current.fold(
              (_) {
            state = state.copyWith(
              isLoading: false,
              successMessage: "Account created successfully",
            );
          },
              (user) {
            state = state.copyWith(
              isLoading: false,
              user: user,
              successMessage: "Account created successfully",
            );
          },
        );
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    final result = await _logoutUseCase();

    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
          (_) {
        state = state.copyWith(
          isLoading: false,
          user: null,
          successMessage: "Logged out",
        );
      },
    );
  }
}
