import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/rating/data/repository/rating_repository.dart';
import 'package:client/features/rating/domain/entities/rating_entity.dart';
import 'package:client/features/rating/domain/repositories/rating_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetUserRatingsParams extends Equatable {
  final String targetId;
  const GetUserRatingsParams({required this.targetId});

  @override
  List<Object?> get props => [targetId];
}

final getUserRatingsUsecaseProvider = Provider<GetUserRatingsUsecase>((ref) {
  final ratingRepository = ref.read(ratingRepositoryProvider);
  return GetUserRatingsUsecase(ratingRepository: ratingRepository);
});

class GetUserRatingsUsecase
    implements UsecaseWithParams<List<RatingEntity>, GetUserRatingsParams> {
  final IRatingRepository _ratingRepository;

  GetUserRatingsUsecase({required IRatingRepository ratingRepository})
    : _ratingRepository = ratingRepository;

  @override
  Future<Either<Failure, List<RatingEntity>>> call(
    GetUserRatingsParams params,
  ) {
    return _ratingRepository.getUserRatings(params.targetId);
  }
}
