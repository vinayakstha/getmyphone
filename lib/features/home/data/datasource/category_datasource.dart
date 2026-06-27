import 'package:client/features/home/data/model/category_api_model.dart';

abstract interface class ICategoryRemoteDataSource {
  Future<List<CategoryApiModel>> getAllCategories();
  Future<CategoryApiModel> getCategoryById(String id);
}
