import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/phone/data/repository/phone_repository.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePhoneParams extends Equatable {
  final PhoneEntity phone;
  final String? photoPath;

  const CreatePhoneParams({required this.phone, this.photoPath});

  @override
  List<Object?> get props => [phone, photoPath];
}

final createPhoneUsecaseProvider = Provider<CreatePhoneUsecase>((ref) {
  final phoneRepository = ref.read(phoneRepositoryProvider);
  return CreatePhoneUsecase(phoneRepository: phoneRepository);
});

class CreatePhoneUsecase
    implements UsecaseWithParams<PhoneEntity, CreatePhoneParams> {
  final IPhoneRepository _phoneRepository;

  CreatePhoneUsecase({required IPhoneRepository phoneRepository})
    : _phoneRepository = phoneRepository;

  @override
  Future<Either<Failure, PhoneEntity>> call(CreatePhoneParams params) {
    return _phoneRepository.createPhone(
      params.phone,
      photoPath: params.photoPath,
    );
  }
}
