import 'package:client/core/error/failures.dart';
import 'package:client/features/category/data/datasource/category_datasource.dart';
import 'package:client/features/category/data/datasource/remote/category_remote_datasource.dart';
import 'package:client/features/category/data/model/category_api_model.dart';
import 'package:client/features/category/domain/entities/category_entity.dart';
import 'package:client/features/category/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryRemoteDataSource = ref.read(categoryRemoteDataSourceProvider);
  return CategoryRepository(categoryRemoteDataSource: categoryRemoteDataSource);
});

class CategoryRepository implements ICategoryRepository {
  final ICategoryRemoteDataSource _categoryRemoteDataSource;

  CategoryRepository({
    required ICategoryRemoteDataSource categoryRemoteDataSource,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final result = await _categoryRemoteDataSource.getAllCategories();
      return Right(CategoryApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch categories',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    try {
      final result = await _categoryRemoteDataSource.getCategoryById(id);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch category',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
