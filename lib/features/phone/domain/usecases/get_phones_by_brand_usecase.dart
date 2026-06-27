import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/phone/data/repository/phone_repository.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetPhonesByBrandParams extends Equatable {
  final String brandId;
  const GetPhonesByBrandParams({required this.brandId});

  @override
  List<Object?> get props => [brandId];
}

final getPhonesByBrandUsecaseProvider = Provider<GetPhonesByBrandUsecase>((
  ref,
) {
  final phoneRepository = ref.read(phoneRepositoryProvider);
  return GetPhonesByBrandUsecase(phoneRepository: phoneRepository);
});

class GetPhonesByBrandUsecase
    implements UsecaseWithParams<List<PhoneEntity>, GetPhonesByBrandParams> {
  final IPhoneRepository _phoneRepository;

  GetPhonesByBrandUsecase({required IPhoneRepository phoneRepository})
    : _phoneRepository = phoneRepository;

  @override
  Future<Either<Failure, List<PhoneEntity>>> call(
    GetPhonesByBrandParams params,
  ) {
    return _phoneRepository.getPhonesByBrand(params.brandId);
  }
}
