import 'package:client/core/error/failures.dart';
import 'package:client/features/auth/domain/entities/auth_entity.dart';
import 'package:client/features/profile/data/datasource/user_datasource.dart';
import 'package:client/features/profile/data/datasource/remote/user_remote_datasource.dart';
import 'package:client/features/profile/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final userRemoteDataSource = ref.read(userRemoteDataSourceProvider);
  return UserRepository(userRemoteDataSource: userRemoteDataSource);
});

class UserRepository implements IUserRepository {
  final IUserRemoteDataSource _userRemoteDataSource;

  UserRepository({required IUserRemoteDataSource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Either<Failure, AuthEntity>> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoPath,
  }) async {
    try {
      final result = await _userRemoteDataSource.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        photoPath: photoPath,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update profile',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final result = await _userRemoteDataSource.getCurrentUser();
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch user',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
