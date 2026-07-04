import 'package:client/core/api/api_client.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/token_service.dart';
import 'package:client/core/services/storage/user_session_service.dart';
import 'package:client/features/auth/data/model/auth_api_model.dart';
import 'package:client/features/profile/data/datasource/user_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteDataSourceProvider = Provider<IUserRemoteDataSource>((ref) {
  return UserRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class UserRemoteDataSource implements IUserRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final UserSessionService _userSessionService;

  UserRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoPath,
  }) async {
    final token = _tokenService.getToken();

    final formData = FormData.fromMap({
      ?'fullName': fullName,
      ?'email': email,
      ?'phoneNumber': phoneNumber,
      if (photoPath != null)
        'profilePicture': await MultipartFile.fromFile(photoPath),
    });

    final response = await _apiClient.updateFile(
      ApiEndpoints.updateProfile,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    final user = AuthApiModel.fromJson(data);

    await _userSessionService.saveUserSession(
      userId: user.id!,
      email: user.email,
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      profilePicture: user.profilePicture,
      ratingAverage: user.ratingAverage,
      ratingCount: user.ratingCount,
    );

    return user;
  }

  @override
  Future<AuthApiModel> getCurrentUser() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.getCurrentUser,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return AuthApiModel.fromJson(data);
  }
}
