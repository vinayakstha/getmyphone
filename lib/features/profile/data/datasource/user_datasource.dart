import 'package:client/features/auth/data/model/auth_api_model.dart';

abstract interface class IUserRemoteDataSource {
  Future<AuthApiModel> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoPath,
  });
  Future<AuthApiModel> getCurrentUser();
}
