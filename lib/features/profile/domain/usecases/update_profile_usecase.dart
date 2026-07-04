import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/auth/domain/entities/auth_entity.dart';
import 'package:client/features/profile/data/repository/user_repository.dart';
import 'package:client/features/profile/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfileParams extends Equatable {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? photoPath;

  const UpdateProfileParams({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.photoPath,
  });

  @override
  List<Object?> get props => [fullName, email, phoneNumber, photoPath];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateProfileUsecase(userRepository: userRepository);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<AuthEntity, UpdateProfileParams> {
  final IUserRepository _userRepository;

  UpdateProfileUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) {
    return _userRepository.updateProfile(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      photoPath: params.photoPath,
    );
  }
}
