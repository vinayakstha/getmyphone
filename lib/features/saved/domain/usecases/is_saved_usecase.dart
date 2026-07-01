import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/saved/data/repository/saved_repository.dart';
import 'package:client/features/saved/domain/repositories/saved_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsSavedParams extends Equatable {
  final String phoneId;
  const IsSavedParams({required this.phoneId});

  @override
  List<Object?> get props => [phoneId];
}

final isSavedUsecaseProvider = Provider<IsSavedUsecase>((ref) {
  final savedRepository = ref.read(savedRepositoryProvider);
  return IsSavedUsecase(savedRepository: savedRepository);
});

class IsSavedUsecase implements UsecaseWithParams<bool, IsSavedParams> {
  final ISavedRepository _savedRepository;

  IsSavedUsecase({required ISavedRepository savedRepository})
    : _savedRepository = savedRepository;

  @override
  Future<Either<Failure, bool>> call(IsSavedParams params) {
    return _savedRepository.isSaved(params.phoneId);
  }
}
