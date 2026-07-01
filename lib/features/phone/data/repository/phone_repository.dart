import 'package:client/core/error/failures.dart';
import 'package:client/features/phone/data/datasource/phone_datasource.dart';
import 'package:client/features/phone/data/datasource/remote/phone_remote_datasource.dart';
import 'package:client/features/phone/data/model/phone_api_model.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:client/features/phone/domain/repositories/phone_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneRepositoryProvider = Provider<IPhoneRepository>((ref) {
  final phoneRemoteDataSource = ref.read(phoneRemoteDataSourceProvider);
  return PhoneRepository(phoneRemoteDataSource: phoneRemoteDataSource);
});

class PhoneRepository implements IPhoneRepository {
  final IPhoneRemoteDataSource _phoneRemoteDataSource;

  PhoneRepository({required IPhoneRemoteDataSource phoneRemoteDataSource})
    : _phoneRemoteDataSource = phoneRemoteDataSource;

  @override
  Future<Either<Failure, PhoneEntity>> createPhone(
    PhoneEntity phone, {
    String? photoPath,
  }) async {
    try {
      final model = PhoneApiModel.fromEntity(phone);
      final result = await _phoneRemoteDataSource.createPhone(
        model,
        photoPath: photoPath,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to create listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhoneEntity>> getPhoneById(String id) async {
    try {
      final result = await _phoneRemoteDataSource.getPhoneById(id);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PhoneEntity>>> getAllPhones() async {
    try {
      final result = await _phoneRemoteDataSource.getAllPhones();
      return Right(PhoneApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch listings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PhoneEntity>>> getPhonesBySeller() async {
    try {
      final result = await _phoneRemoteDataSource.getPhonesBySeller();
      return Right(PhoneApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch your listings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PhoneEntity>>> getPhonesByBrand(
    String brandId,
  ) async {
    try {
      final result = await _phoneRemoteDataSource.getPhonesByBrand(brandId);
      return Right(PhoneApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ??
              'Failed to fetch listings by brand',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PhoneEntity>>> getPhonesNearLocation(
    double lng,
    double lat, {
    double? maxDistance,
  }) async {
    try {
      final result = await _phoneRemoteDataSource.getPhonesNearLocation(
        lng,
        lat,
        maxDistance: maxDistance,
      );
      return Right(PhoneApiModel.toEntityList(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch nearby listings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhoneEntity>> updatePhone(
    String id,
    PhoneEntity phone, {
    String? photoPath,
  }) async {
    try {
      final model = PhoneApiModel.fromEntity(phone);
      final result = await _phoneRemoteDataSource.updatePhone(
        id,
        model,
        photoPath: photoPath,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePhone(String id) async {
    try {
      final result = await _phoneRemoteDataSource.deletePhone(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to delete listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
