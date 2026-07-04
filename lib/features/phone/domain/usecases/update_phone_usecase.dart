import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/phone/data/repository/phone_repository.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdatePhoneParams extends Equatable {
  final String id;
  final PhoneEntity phone;
  final String? photoPath;

  const UpdatePhoneParams({
    required this.id,
    required this.phone,
    this.photoPath,
  });

  @override
  List<Object?> get props => [id, phone, photoPath];
}

final updatePhoneUsecaseProvider = Provider<UpdatePhoneUsecase>((ref) {
  final phoneRepository = ref.read(phoneRepositoryProvider);
  return UpdatePhoneUsecase(phoneRepository: phoneRepository);
});

class UpdatePhoneUsecase
    implements UsecaseWithParams<PhoneEntity, UpdatePhoneParams> {
  final IPhoneRepository _phoneRepository;

  UpdatePhoneUsecase({required IPhoneRepository phoneRepository})
    : _phoneRepository = phoneRepository;

  @override
  Future<Either<Failure, PhoneEntity>> call(UpdatePhoneParams params) {
    return _phoneRepository.updatePhone(
      params.id,
      params.phone,
      photoPath: params.photoPath,
    );
  }
}
