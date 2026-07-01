import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/saved/data/repository/saved_repository.dart';
import 'package:client/features/saved/domain/repositories/saved_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleSaveParams extends Equatable {
  final String phoneId;
  const ToggleSaveParams({required this.phoneId});

  @override
  List<Object?> get props => [phoneId];
}

final toggleSaveUsecaseProvider = Provider<ToggleSaveUsecase>((ref) {
  final savedRepository = ref.read(savedRepositoryProvider);
  return ToggleSaveUsecase(savedRepository: savedRepository);
});

class ToggleSaveUsecase
    implements UsecaseWithParams<Map<String, dynamic>, ToggleSaveParams> {
  final ISavedRepository _savedRepository;

  ToggleSaveUsecase({required ISavedRepository savedRepository})
    : _savedRepository = savedRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(ToggleSaveParams params) {
    return _savedRepository.toggleSave(params.phoneId);
  }
}
