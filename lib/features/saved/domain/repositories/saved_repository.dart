import 'package:client/core/error/failures.dart';
import 'package:client/features/saved/domain/entities/saved_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ISavedRepository {
  Future<Either<Failure, Map<String, dynamic>>> toggleSave(String phoneId);
  Future<Either<Failure, List<SavedEntity>>> getSavedByUser();
  Future<Either<Failure, bool>> isSaved(String phoneId);
}
