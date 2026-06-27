import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/phone/data/repository/phone_repository.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletePhoneParams extends Equatable {
  final String id;
  const DeletePhoneParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deletePhoneUsecaseProvider = Provider<DeletePhoneUsecase>((ref) {
  final phoneRepository = ref.read(phoneRepositoryProvider);
  return DeletePhoneUsecase(phoneRepository: phoneRepository);
});

class DeletePhoneUsecase implements UsecaseWithParams<bool, DeletePhoneParams> {
  final IPhoneRepository _phoneRepository;

  DeletePhoneUsecase({required IPhoneRepository phoneRepository})
    : _phoneRepository = phoneRepository;

  @override
  Future<Either<Failure, bool>> call(DeletePhoneParams params) {
    return _phoneRepository.deletePhone(params.id);
  }
}
