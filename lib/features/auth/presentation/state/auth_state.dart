import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final AuthEntity? user;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    required this.isLoading,
    required this.user,
    required this.errorMessage,
    required this.successMessage,
  });

  const AuthState.initial()
      : isLoading = false,
        user = null,
        errorMessage = null,
        successMessage = null;

  AuthState copyWith({
    bool? isLoading,
    AuthEntity? user,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
      clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, user, errorMessage, successMessage];
}
