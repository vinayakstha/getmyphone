import 'package:client/features/home/domain/entities/category_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:client/core/error/failures.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);
}
