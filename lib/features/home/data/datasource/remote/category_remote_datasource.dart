import 'package:client/core/api/api_client.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/features/home/data/datasource/category_datasource.dart';
import 'package:client/features/home/data/model/category_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRemoteDataSourceProvider = Provider<ICategoryRemoteDataSource>((
  ref,
) {
  return CategoryRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class CategoryRemoteDataSource implements ICategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    final response = await _apiClient.get(ApiEndpoints.getAllCategories);
    final data = response.data['data'] as List;
    return data.map((e) => CategoryApiModel.fromJson(e)).toList();
  }

  @override
  Future<CategoryApiModel> getCategoryById(String id) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.getCategoryById}/$id',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return CategoryApiModel.fromJson(data);
  }
}
