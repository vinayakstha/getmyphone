import 'package:client/core/error/failures.dart';
import 'package:client/features/saved/data/datasource/saved_datasource.dart';
import 'package:client/features/saved/data/datasource/remote/saved_remote_datasource.dart';
import 'package:client/features/saved/data/model/saved_api_model.dart';
import 'package:client/features/saved/domain/entities/saved_entity.dart';
import 'package:client/features/saved/domain/repositories/saved_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedRepositoryProvider = Provider<ISavedRepository>((ref) {
  final savedRemoteDataSource = ref.read(savedRemoteDataSourceProvider);
  return SavedRepository(savedRemoteDataSource: savedRemoteDataSource);
});

class SavedRepository implements ISavedRepository {
  final ISavedRemoteDataSource _savedRemoteDataSource;

  SavedRepository({required ISavedRemoteDataSource savedRemoteDataSource})
    : _savedRemoteDataSource = savedRemoteDataSource;

  @override
  Future<Either<Failure, Map<String, dynamic>>> toggleSave(
    String phoneId,
  ) async {
    try {
      final result = await _savedRemoteDataSource.toggleSave(phoneId);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to toggle save',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedEntity>>> getSavedByUser() async {
    try {
      final result = await _savedRemoteDataSource.getSavedByUser();
      return Right(SavedApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch saved listings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSaved(String phoneId) async {
    try {
      final result = await _savedRemoteDataSource.isSaved(phoneId);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to check saved status',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
