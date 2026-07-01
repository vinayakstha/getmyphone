import 'package:client/core/error/failures.dart';
import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IPhoneRepository {
  Future<Either<Failure, PhoneEntity>> createPhone(
    PhoneEntity phone, {
    String? photoPath,
  });
  Future<Either<Failure, PhoneEntity>> getPhoneById(String id);
  Future<Either<Failure, List<PhoneEntity>>> getAllPhones();
  Future<Either<Failure, List<PhoneEntity>>> getPhonesBySeller();
  Future<Either<Failure, List<PhoneEntity>>> getPhonesByBrand(String brandId);
  Future<Either<Failure, List<PhoneEntity>>> getPhonesNearLocation(
    double lng,
    double lat, {
    double? maxDistance,
  });
  Future<Either<Failure, PhoneEntity>> updatePhone(
    String id,
    PhoneEntity phone, {
    String? photoPath,
  });
  Future<Either<Failure, bool>> deletePhone(String id);
}
