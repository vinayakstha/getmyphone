import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/phone/data/repository/phone_repository.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetPhoneByIdParams extends Equatable {
  final String id;
  const GetPhoneByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getPhoneByIdUsecaseProvider = Provider<GetPhoneByIdUsecase>((ref) {
  final phoneRepository = ref.read(phoneRepositoryProvider);
  return GetPhoneByIdUsecase(phoneRepository: phoneRepository);
});

class GetPhoneByIdUsecase
    implements UsecaseWithParams<PhoneEntity, GetPhoneByIdParams> {
  final IPhoneRepository _phoneRepository;

  GetPhoneByIdUsecase({required IPhoneRepository phoneRepository})
    : _phoneRepository = phoneRepository;

  @override
  Future<Either<Failure, PhoneEntity>> call(GetPhoneByIdParams params) {
    return _phoneRepository.getPhoneById(params.id);
  }
}
