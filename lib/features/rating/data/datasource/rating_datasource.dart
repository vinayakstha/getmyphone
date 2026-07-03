import 'package:client/features/rating/data/model/rating_api_model.dart';

abstract interface class IRatingRemoteDataSource {
  Future<RatingApiModel> submitRating({
    required String targetId,
    required double score,
  });
  Future<List<RatingApiModel>> getUserRatings(String targetId);
}
