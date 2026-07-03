import 'package:client/core/api/api_client.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/token_service.dart';
import 'package:client/features/rating/data/datasource/rating_datasource.dart';
import 'package:client/features/rating/data/model/rating_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratingRemoteDataSourceProvider = Provider<IRatingRemoteDataSource>((ref) {
  return RatingRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class RatingRemoteDataSource implements IRatingRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  RatingRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<RatingApiModel> submitRating({
    required String targetId,
    required double score,
  }) async {
    final token = _tokenService.getToken();
    await _apiClient.post(
      ApiEndpoints.submitRating,
      data: {'targetId': targetId, 'score': score},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return RatingApiModel(raterId: '', targetId: targetId, score: score);
  }

  @override
  Future<List<RatingApiModel>> getUserRatings(String targetId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.getUserRatings}/$targetId',
    );
    final data = response.data['data'] as List;
    return data.map((e) => RatingApiModel.fromJson(e)).toList();
  }
}
