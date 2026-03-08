import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:quick_menu/core/error/failure.dart';

// Mock UseCase
class MockGetUserProfileUseCase extends Mock {
  Future<Either<Failure, UserProfile>> call(String userId);
}

class MockUpdateUserProfileUseCase extends Mock {
  Future<Either<Failure, UserProfile>> call(UserProfile profile);
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  UserProfile(this.id, this.name, this.email);
}

// State classes
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileUpdating extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// ViewModel
class ProfileViewModel extends StateNotifier<ProfileState> {
  final MockGetUserProfileUseCase getUserProfileUseCase;
  final MockUpdateUserProfileUseCase updateUserProfileUseCase;

  ProfileViewModel(this.getUserProfileUseCase, this.updateUserProfileUseCase)
    : super(ProfileInitial());

  Future<void> loadProfile(String userId) async {
    state = ProfileLoading();
    final result = await getUserProfileUseCase(userId);
    result.fold(
      (failure) => state = ProfileError(failure.message),
      (profile) => state = ProfileLoaded(profile),
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = ProfileUpdating();
    final result = await updateUserProfileUseCase(profile);
    result.fold(
      (failure) => state = ProfileError(failure.message),
      (updatedProfile) => state = ProfileLoaded(updatedProfile),
    );
  }
}

void main() {
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late ProfileViewModel viewModel;

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    viewModel = ProfileViewModel(
      mockGetUserProfileUseCase,
      mockUpdateUserProfileUseCase,
    );
  });

  setUpAll(() {
    registerFallbackValue(UserProfile('1', 'Test', 'test@test.com'));
  });

  group('Profile ViewModel Tests', () {
    test('initial state should be ProfileInitial', () {
      expect(viewModel.state, isA<ProfileInitial>());
    });

    test('should load user profile successfully', () async {
      // Arrange
      final tProfile = UserProfile('1', 'John', 'john@test.com');
      when(
        () => mockGetUserProfileUseCase('1'),
      ).thenAnswer((_) async => Right(tProfile));

      // Act
      await viewModel.loadProfile('1');

      // Assert
      expect(viewModel.state, isA<ProfileLoaded>());
      expect((viewModel.state as ProfileLoaded).profile.name, 'John');
    });

    test('should update user profile successfully', () async {
      // Arrange
      final tProfile = UserProfile('1', 'John Updated', 'john@test.com');
      when(
        () => mockUpdateUserProfileUseCase(tProfile),
      ).thenAnswer((_) async => Right(tProfile));

      // Act
      await viewModel.updateProfile(tProfile);

      // Assert
      expect(viewModel.state, isA<ProfileLoaded>());
      expect((viewModel.state as ProfileLoaded).profile.name, 'John Updated');
    });

    test('should emit ProfileError when loading fails', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'User not found');
      when(
        () => mockGetUserProfileUseCase('999'),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      await viewModel.loadProfile('999');

      // Assert
      expect(viewModel.state, isA<ProfileError>());
    });
  });
}
