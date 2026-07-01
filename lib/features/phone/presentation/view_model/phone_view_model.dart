import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/usecases/create_phone_usecase.dart';
import 'package:client/features/phone/domain/usecases/delete_phone_usecase.dart';
import 'package:client/features/phone/domain/usecases/get_all_phones.usecase.dart';
import 'package:client/features/phone/domain/usecases/get_phone_by_id_usecase.dart';
import 'package:client/features/phone/domain/usecases/get_phones_by_brand_usecase.dart';
import 'package:client/features/phone/domain/usecases/get_phones_by_seller_usecase.dart';
import 'package:client/features/phone/presentation/state/phone_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneViewModelProvider = NotifierProvider<PhoneViewModel, PhoneState>(
  () => PhoneViewModel(),
);

class PhoneViewModel extends Notifier<PhoneState> {
  late final CreatePhoneUsecase _createPhoneUsecase;
  late final GetAllPhonesUsecase _getAllPhonesUsecase;
  late final GetPhoneByIdUsecase _getPhoneByIdUsecase;
  late final GetPhonesBySellerUsecase _getPhonesBySellerUsecase;
  late final GetPhonesByBrandUsecase _getPhonesByBrandUsecase;
  late final DeletePhoneUsecase _deletePhoneUsecase;

  @override
  PhoneState build() {
    _createPhoneUsecase = ref.read(createPhoneUsecaseProvider);
    _getAllPhonesUsecase = ref.read(getAllPhonesUsecaseProvider);
    _getPhoneByIdUsecase = ref.read(getPhoneByIdUsecaseProvider);
    _getPhonesBySellerUsecase = ref.read(getPhonesBySellerUsecaseProvider);
    _getPhonesByBrandUsecase = ref.read(getPhonesByBrandUsecaseProvider);
    _deletePhoneUsecase = ref.read(deletePhoneUsecaseProvider);
    return const PhoneState();
  }

  Future<void> createPhone(PhoneEntity phone, {String? photoPath}) async {
    state = state.copyWith(status: PhoneStatus.loading);

    final result = await _createPhoneUsecase(
      CreatePhoneParams(phone: phone, photoPath: photoPath),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: PhoneStatus.error,
        errorMessage: failure.message,
      ),
      (phone) => state = state.copyWith(
        status: PhoneStatus.created,
        selectedPhone: phone,
      ),
    );
  }

  Future<void> getAllPhones() async {
    state = state.copyWith(status: PhoneStatus.loading);

    final result = await _getAllPhonesUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: PhoneStatus.error,
        errorMessage: failure.message,
      ),
      (phones) =>
          state = state.copyWith(status: PhoneStatus.loaded, phones: phones),
    );
  }

  Future<void> getPhoneById(String id) async {
    state = state.copyWith(status: PhoneStatus.loading);

    final result = await _getPhoneByIdUsecase(GetPhoneByIdParams(id: id));

    result.fold(
      (failure) => state = state.copyWith(
        status: PhoneStatus.error,
        errorMessage: failure.message,
      ),
      (phone) => state = state.copyWith(
        status: PhoneStatus.loaded,
        selectedPhone: phone,
      ),
    );
  }

  Future<void> getPhonesBySeller() async {
    state = state.copyWith(status: PhoneStatus.loading);

    final result = await _getPhonesBySellerUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: PhoneStatus.error,
        errorMessage: failure.message,
      ),
      (phones) =>
          state = state.copyWith(status: PhoneStatus.loaded, phones: phones),
    );
  }

  Future<void> getPhonesByBrand(String brandId) async {
    state = state.copyWith(status: PhoneStatus.loading);

    final result = await _getPhonesByBrandUsecase(
      GetPhonesByBrandParams(brandId: brandId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: PhoneStatus.error,
        errorMessage: failure.message,
      ),
      (phones) =>
          state = state.copyWith(status: PhoneStatus.loaded, phones: phones),
    );
  }

  Future<void> deletePhone(String id) async {
    state = state.copyWith(status: PhoneStatus.loading);

    final result = await _deletePhoneUsecase(DeletePhoneParams(id: id));

    result.fold(
      (failure) => state = state.copyWith(
        status: PhoneStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: PhoneStatus.deleted,
        phones: state.phones.where((p) => p.phoneId != id).toList(),
      ),
    );
  }
}
