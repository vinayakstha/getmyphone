import 'package:client/features/category/presentation/state/category_phone_state.dart';
import 'package:client/features/phone/domain/usecases/get_phones_by_brand_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryPhoneViewModelProvider =
    NotifierProvider<CategoryPhoneViewModel, CategoryPhoneState>(
      () => CategoryPhoneViewModel(),
    );

class CategoryPhoneViewModel extends Notifier<CategoryPhoneState> {
  late final GetPhonesByBrandUsecase _getPhonesByBrandUsecase;

  @override
  CategoryPhoneState build() {
    _getPhonesByBrandUsecase = ref.read(getPhonesByBrandUsecaseProvider);
    return const CategoryPhoneState();
  }

  Future<void> getPhonesByBrand(String brandId) async {
    state = state.copyWith(status: CategoryPhoneStatus.loading);

    final result = await _getPhonesByBrandUsecase(
      GetPhonesByBrandParams(brandId: brandId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: CategoryPhoneStatus.error,
        errorMessage: failure.message,
      ),
      (phones) => state = state.copyWith(
        status: CategoryPhoneStatus.loaded,
        phones: phones,
      ),
    );
  }
}
