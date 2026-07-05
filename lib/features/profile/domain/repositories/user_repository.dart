import 'package:client/core/error/failures.dart';
import 'package:client/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, AuthEntity>> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoPath,
  });
  Future<Either<Failure, AuthEntity>> getCurrentUser();
}
