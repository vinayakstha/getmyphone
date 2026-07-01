import 'package:client/core/api/api_client.dart';
import 'package:client/core/api/api_endpoints.dart';
import 'package:client/core/services/storage/token_service.dart';
import 'package:client/features/phone/data/datasource/phone_datasource.dart';
import 'package:client/features/phone/data/model/phone_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

final phoneRemoteDataSourceProvider = Provider<IPhoneRemoteDataSource>((ref) {
  return PhoneRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class PhoneRemoteDataSource implements IPhoneRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  PhoneRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<PhoneApiModel> createPhone(
    PhoneApiModel phone, {
    String? photoPath,
  }) async {
    final token = _tokenService.getToken();

    FormData formData = FormData.fromMap({
      'title': phone.title,
      'brand': phone.brand,
      'condition': phone.condition,
      'location': jsonEncode(phone.location.toJson()),
      'description': phone.description,
      'cpu': phone.cpu,
      'storage': phone.storage,
      'ram': phone.ram,
      'screen': phone.screen,
      'battery': phone.battery,
      'camera': phone.camera,
      'usedFor': phone.usedFor,
      'negotiable': phone.negotiable,
      'price': phone.price,
      if (photoPath != null) 'photo': await MultipartFile.fromFile(photoPath),
    });

    final response = await _apiClient.uploadFile(
      ApiEndpoints.createPhone,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return PhoneApiModel.fromJson(response.data['data']);
  }

  @override
  Future<PhoneApiModel> getPhoneById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.getPhoneById}/$id');
    return PhoneApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<PhoneApiModel>> getAllPhones() async {
    final response = await _apiClient.get(ApiEndpoints.getAllPhones);
    final data = response.data['data'] as List;
    return data.map((e) => PhoneApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<PhoneApiModel>> getPhonesBySeller() async {
    final token = _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.getPhonesBySeller,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => PhoneApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<PhoneApiModel>> getPhonesByBrand(String brandId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.getPhonesByBrand}/$brandId',
    );
    final data = response.data['data'] as List;
    return data.map((e) => PhoneApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<PhoneApiModel>> getPhonesNearLocation(
    double lng,
    double lat, {
    double? maxDistance,
  }) async {
    final queryParams = {
      'lng': lng.toString(),
      'lat': lat.toString(),
      if (maxDistance != null) 'maxDistance': maxDistance.toString(),
    };
    final response = await _apiClient.get(
      ApiEndpoints.getPhonesNearLocation,
      queryParameters: queryParams,
    );
    final data = response.data['data'] as List;
    return data.map((e) => PhoneApiModel.fromJson(e)).toList();
  }

  @override
  Future<PhoneApiModel> updatePhone(
    String id,
    PhoneApiModel phone, {
    String? photoPath,
  }) async {
    final token = _tokenService.getToken();

    FormData formData = FormData.fromMap({
      'title': phone.title,
      'brand': phone.brand,
      'condition': phone.condition,
      'location': phone.location.toJson().toString(),
      'description': phone.description,
      'cpu': phone.cpu,
      'storage': phone.storage,
      'ram': phone.ram,
      'screen': phone.screen,
      'battery': phone.battery,
      'camera': phone.camera,
      'usedFor': phone.usedFor,
      'negotiable': phone.negotiable,
      'price': phone.price,
      if (photoPath != null) 'photo': await MultipartFile.fromFile(photoPath),
    });

    final response = await _apiClient.updateFile(
      '${ApiEndpoints.updatePhone}/$id',
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return PhoneApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> deletePhone(String id) async {
    final token = _tokenService.getToken();
    await _apiClient.delete(
      '${ApiEndpoints.deletePhone}/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }
}
