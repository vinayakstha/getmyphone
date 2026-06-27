import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/home/domain/entities/category_entity.dart';
import 'package:client/features/home/domain/repositories/category_repository.dart';
import 'package:client/features/home/data/repository/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllCategoriesUsecaseProvider = Provider<GetAllCategoriesUsecase>((
  ref,
) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetAllCategoriesUsecase(categoryRepository: categoryRepository);
});

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
