import 'package:client/features/saved/domain/usecases/get_saved_by_user_usecase.dart';
import 'package:client/features/saved/domain/usecases/is_saved_usecase.dart';
import 'package:client/features/saved/domain/usecases/toggle_save_usecase.dart';
import 'package:client/features/saved/presentation/state/saved_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedViewModelProvider = NotifierProvider<SavedViewModel, SavedState>(
  () => SavedViewModel(),
);

class SavedViewModel extends Notifier<SavedState> {
  late final ToggleSaveUsecase _toggleSaveUsecase;
  late final GetSavedByUserUsecase _getSavedByUserUsecase;
  late final IsSavedUsecase _isSavedUsecase;

  @override
  SavedState build() {
    _toggleSaveUsecase = ref.read(toggleSaveUsecaseProvider);
    _getSavedByUserUsecase = ref.read(getSavedByUserUsecaseProvider);
    _isSavedUsecase = ref.read(isSavedUsecaseProvider);
    return const SavedState();
  }

  Future<void> toggleSave(String phoneId) async {
    state = state.copyWith(status: SavedStatus.loading);

    final result = await _toggleSaveUsecase(ToggleSaveParams(phoneId: phoneId));

    result.fold(
      (failure) => state = state.copyWith(
        status: SavedStatus.error,
        errorMessage: failure.message,
      ),
      (data) {
        final isSaved = data['saved'] as bool;
        final updatedIds = Set<String>.from(state.savedPhoneIds);
        if (isSaved) {
          updatedIds.add(phoneId);
        } else {
          updatedIds.remove(phoneId);
        }
        state = state.copyWith(
          status: SavedStatus.toggled,
          isSaved: isSaved,
          savedPhoneIds: updatedIds,
        );
      },
    );
  }

  Future<void> getSavedByUser() async {
    state = state.copyWith(status: SavedStatus.loading);

    final result = await _getSavedByUserUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: SavedStatus.error,
        errorMessage: failure.message,
      ),
      (savedListings) => state = state.copyWith(
        status: SavedStatus.loaded,
        savedListings: savedListings,
        savedPhoneIds: savedListings.map((e) => e.phone.phoneId ?? '').toSet(),
      ),
    );
  }

  Future<void> isSaved(String phoneId) async {
    final result = await _isSavedUsecase(IsSavedParams(phoneId: phoneId));

    result.fold(
      (failure) => state = state.copyWith(
        status: SavedStatus.error,
        errorMessage: failure.message,
      ),
      (isSaved) => state = state.copyWith(isSaved: isSaved),
    );
  }
}
