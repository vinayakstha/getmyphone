import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/phone/data/repository/phone_repository.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPhonesBySellerUsecaseProvider = Provider<GetPhonesBySellerUsecase>((
  ref,
) {
  final phoneRepository = ref.read(phoneRepositoryProvider);
  return GetPhonesBySellerUsecase(phoneRepository: phoneRepository);
});

class GetPhonesBySellerUsecase
    implements UsecaseWithoutParams<List<PhoneEntity>> {
  final IPhoneRepository _phoneRepository;

  GetPhonesBySellerUsecase({required IPhoneRepository phoneRepository})
    : _phoneRepository = phoneRepository;

  @override
  Future<Either<Failure, List<PhoneEntity>>> call() {
    return _phoneRepository.getPhonesBySeller();
  }
}
