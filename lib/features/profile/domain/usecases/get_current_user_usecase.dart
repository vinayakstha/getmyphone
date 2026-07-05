import 'package:client/core/error/failures.dart';
import 'package:client/core/usecase/app_usecase.dart';
import 'package:client/features/auth/domain/entities/auth_entity.dart';
import 'package:client/features/profile/data/repository/user_repository.dart';
import 'package:client/features/profile/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetCurrentUserUsecase(userRepository: userRepository);
});

class GetCurrentUserUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IUserRepository _userRepository;

  GetCurrentUserUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _userRepository.getCurrentUser();
  }
}
