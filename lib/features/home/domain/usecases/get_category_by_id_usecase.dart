import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/home/domain/entities/category_entity.dart';
import 'package:client/features/home/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetCategoryByIdParams extends Equatable {
  final String id;
  const GetCategoryByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetCategoryByIdUsecase
    implements UsecaseWithParams<CategoryEntity, GetCategoryByIdParams> {
  final ICategoryRepository _categoryRepository;

  GetCategoryByIdUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, CategoryEntity>> call(GetCategoryByIdParams params) {
    return _categoryRepository.getCategoryById(params.id);
  }
}
