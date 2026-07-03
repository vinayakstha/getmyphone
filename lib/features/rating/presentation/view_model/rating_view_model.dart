import 'package:client/features/rating/domain/usecases/get_user_ratings_usecase.dart';
import 'package:client/features/rating/domain/usecases/submit_rating_usecase.dart';
import 'package:client/features/rating/presentation/state/rating_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratingViewModelProvider = NotifierProvider<RatingViewModel, RatingState>(
  () => RatingViewModel(),
);

class RatingViewModel extends Notifier<RatingState> {
  late final SubmitRatingUsecase _submitRatingUsecase;
  late final GetUserRatingsUsecase _getUserRatingsUsecase;

  @override
  RatingState build() {
    _submitRatingUsecase = ref.read(submitRatingUsecaseProvider);
    _getUserRatingsUsecase = ref.read(getUserRatingsUsecaseProvider);
    return const RatingState();
  }

  Future<void> submitRating({
    required String targetId,
    required double score,
  }) async {
    state = state.copyWith(status: RatingStatus.loading);

    final result = await _submitRatingUsecase(
      SubmitRatingParams(targetId: targetId, score: score),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: RatingStatus.submitted),
    );
  }

  Future<void> getUserRatings(String targetId) async {
    state = state.copyWith(status: RatingStatus.loading);

    final result = await _getUserRatingsUsecase(
      GetUserRatingsParams(targetId: targetId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStatus.error,
        errorMessage: failure.message,
      ),
      (ratings) =>
          state = state.copyWith(status: RatingStatus.loaded, ratings: ratings),
    );
  }
}
