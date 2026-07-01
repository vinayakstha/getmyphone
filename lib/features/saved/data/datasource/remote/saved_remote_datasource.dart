import 'package:client/core/api/api_client.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/token_service.dart';
import 'package:client/features/saved/data/datasource/saved_datasource.dart';
import 'package:client/features/saved/data/model/saved_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedRemoteDataSourceProvider = Provider<ISavedRemoteDataSource>((ref) {
  return SavedRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class SavedRemoteDataSource implements ISavedRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  SavedRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<Map<String, dynamic>> toggleSave(String phoneId) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.post(
      '${ApiEndpoints.toggleSave}/$phoneId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<List<SavedApiModel>> getSavedByUser() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.getSaved,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => SavedApiModel.fromJson(e)).toList();
  }

  @override
  Future<bool> isSaved(String phoneId) async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      '${ApiEndpoints.isSaved}/$phoneId/is-saved',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['data']['isSaved'] as bool;
  }
}
