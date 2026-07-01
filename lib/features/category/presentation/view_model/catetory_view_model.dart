import 'package:client/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:client/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:client/features/category/presentation/state/category_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(
      () => CategoryViewModel(),
    );

class CategoryViewModel extends Notifier<CategoryState> {
  late final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  late final GetCategoryByIdUsecase _getCategoryByIdUsecase;

  @override
  CategoryState build() {
    _getAllCategoriesUsecase = ref.read(getAllCategoriesUsecaseProvider);
    _getCategoryByIdUsecase = ref.read(getCategoryByIdUsecaseProvider);
    return const CategoryState();
  }

  Future<void> getAllCategories() async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getAllCategoriesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryStatus.error,
        errorMessage: failure.message,
      ),
      (categories) => state = state.copyWith(
        status: CategoryStatus.loaded,
        categories: categories,
      ),
    );
  }

  Future<void> getCategoryById(String id) async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getCategoryByIdUsecase(GetCategoryByIdParams(id: id));

    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryStatus.error,
        errorMessage: failure.message,
      ),
      (category) => state = state.copyWith(
        status: CategoryStatus.loaded,
        selectedCategory: category,
      ),
    );
  }
}
