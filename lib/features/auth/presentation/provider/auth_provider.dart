// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../data/repositories/auth_repository_impl.dart';
// import '../../domain/usecases/login_usecase.dart';
// import '../../domain/usecases/register_usecase.dart';
// import '../../domain/usecases/logout_usecase.dart';
// import '../../domain/usecases/get_current_usecase.dart';
// import '../state/auth_state.dart';
// import '../view_model/auth_view_model.dart';

// // Repository (imported from auth_repository_impl.dart as authRepositoryProvider)

// // UseCases
// final loginUseCaseProvider = Provider(
//   (ref) => LoginUseCase(ref.read(authRepositoryProvider) as AuthRepository),
// );

// final registerUseCaseProvider = Provider(
//   (ref) => RegisterUseCase(ref.read(authRepositoryProvider) as AuthRepository),
// );

// final logoutUseCaseProvider = Provider(
//   (ref) => LogoutUseCase(ref.read(authRepositoryProvider) as AuthRepository),
// );

// final getCurrentUserUseCaseProvider = Provider(
//   (ref) =>
//       GetCurrentUserUseCase(ref.read(authRepositoryProvider) as AuthRepository),
// );

// // ViewModel (Notifier)
// final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
//   final vm = AuthViewModel();
//   // dependencies will be injected in screens (below) OR here using global container.
//   return vm;
// });
