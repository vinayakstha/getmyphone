import 'package:client/core/error/failures.dart';
import 'package:client/features/rating/data/datasource/rating_datasource.dart';
import 'package:client/features/rating/data/datasource/remote/rating_remote_datasource.dart';
import 'package:client/features/rating/data/model/rating_api_model.dart';
import 'package:client/features/rating/domain/entities/rating_entity.dart';
import 'package:client/features/rating/domain/repositories/rating_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratingRepositoryProvider = Provider<IRatingRepository>((ref) {
  final ratingRemoteDataSource = ref.read(ratingRemoteDataSourceProvider);
  return RatingRepository(ratingRemoteDataSource: ratingRemoteDataSource);
});

class RatingRepository implements IRatingRepository {
  final IRatingRemoteDataSource _ratingRemoteDataSource;

  RatingRepository({required IRatingRemoteDataSource ratingRemoteDataSource})
    : _ratingRemoteDataSource = ratingRemoteDataSource;

  @override
  Future<Either<Failure, RatingEntity>> submitRating({
    required String targetId,
    required double score,
  }) async {
    try {
      final result = await _ratingRemoteDataSource.submitRating(
        targetId: targetId,
        score: score,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to submit rating',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RatingEntity>>> getUserRatings(
    String targetId,
  ) async {
    try {
      final result = await _ratingRemoteDataSource.getUserRatings(targetId);
      return Right(RatingApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch ratings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
