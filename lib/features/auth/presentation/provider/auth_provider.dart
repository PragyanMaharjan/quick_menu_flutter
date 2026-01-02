import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_menu/features/auth/data/datasource/local/auth_local_datasource.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_usecase.dart';
import '../state/auth_state.dart';
import '../view_model/auth_view_model.dart';

// DataSource
final authDataSourceProvider = Provider((ref) => AuthLocalDataSource());

// Repository
final authRepositoryProvider =
Provider((ref) => AuthRepositoryImpl(ref.read(authDataSourceProvider)));

// UseCases
final loginUseCaseProvider =
Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));

final registerUseCaseProvider =
Provider((ref) => RegisterUseCase(ref.read(authRepositoryProvider)));

final logoutUseCaseProvider =
Provider((ref) => LogoutUseCase(ref.read(authRepositoryProvider)));

final getCurrentUserUseCaseProvider =
Provider((ref) => GetCurrentUserUseCase(ref.read(authRepositoryProvider)));

// ViewModel (Notifier)
final authViewModelProvider =
NotifierProvider<AuthViewModel, AuthState>(() {
  final vm = AuthViewModel();
  // dependencies will be injected in screens (below) OR here using global container.
  return vm;
});
