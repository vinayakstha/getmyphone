import 'package:client/core/error/failures.dart';
import 'package:client/features/rating/domain/entities/rating_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IRatingRepository {
  Future<Either<Failure, RatingEntity>> submitRating({
    required String targetId,
    required double score,
  });
  Future<Either<Failure, List<RatingEntity>>> getUserRatings(String targetId);
}
