import 'package:client/features/profile/domain/usecases/get_current_user_usecase.dart';
import 'package:client/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:client/features/profile/presentation/state/profile_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;

  @override
  ProfileState build() {
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    return const ProfileState();
  }

  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoPath,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        photoPath: photoPath,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: ProfileStatus.updated, user: user),
    );
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(status: ProfileStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      ),
      (user) =>
          state = state.copyWith(status: ProfileStatus.loaded, user: user),
    );
  }
}
