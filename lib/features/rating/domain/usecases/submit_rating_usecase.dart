import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/rating/data/repository/rating_repository.dart';
import 'package:client/features/rating/domain/entities/rating_entity.dart';
import 'package:client/features/rating/domain/repositories/rating_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmitRatingParams extends Equatable {
  final String targetId;
  final double score;

  const SubmitRatingParams({required this.targetId, required this.score});

  @override
  List<Object?> get props => [targetId, score];
}

final submitRatingUsecaseProvider = Provider<SubmitRatingUsecase>((ref) {
  final ratingRepository = ref.read(ratingRepositoryProvider);
  return SubmitRatingUsecase(ratingRepository: ratingRepository);
});

class SubmitRatingUsecase
    implements UsecaseWithParams<RatingEntity, SubmitRatingParams> {
  final IRatingRepository _ratingRepository;

  SubmitRatingUsecase({required IRatingRepository ratingRepository})
      : _ratingRepository = ratingRepository;

  @override
  Future<Either<Failure, RatingEntity>> call(SubmitRatingParams params) {
    return _ratingRepository.submitRating(
      targetId: params.targetId,
      score: params.score,
    );
  }
}