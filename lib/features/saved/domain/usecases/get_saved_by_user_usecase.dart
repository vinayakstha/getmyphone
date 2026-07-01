import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/saved/data/repository/saved_repository.dart';
import 'package:client/features/saved/domain/entities/saved_entity.dart';
import 'package:client/features/saved/domain/repositories/saved_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSavedByUserUsecaseProvider = Provider<GetSavedByUserUsecase>((ref) {
  final savedRepository = ref.read(savedRepositoryProvider);
  return GetSavedByUserUsecase(savedRepository: savedRepository);
});

class GetSavedByUserUsecase implements UsecaseWithoutParams<List<SavedEntity>> {
  final ISavedRepository _savedRepository;

  GetSavedByUserUsecase({required ISavedRepository savedRepository})
    : _savedRepository = savedRepository;

  @override
  Future<Either<Failure, List<SavedEntity>>> call() {
    return _savedRepository.getSavedByUser();
  }
}
