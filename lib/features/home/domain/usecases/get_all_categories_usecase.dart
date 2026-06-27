import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/home/domain/entities/category_entity.dart';
import 'package:client/features/home/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCategoriesUsecase
    implements UsecaseWithoutParams<List<CategoryEntity>> {
  final ICategoryRepository _categoryRepository;

  GetAllCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _categoryRepository.getAllCategories();
  }
}
