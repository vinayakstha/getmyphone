import 'package:client/features/auth/data/model/auth_api_model.dart';

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String email, String password);
  Future<bool> logout();
}
