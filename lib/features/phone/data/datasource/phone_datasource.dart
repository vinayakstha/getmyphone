import 'package:client/features/phone/data/model/phone_api_model.dart';

abstract interface class IPhoneRemoteDataSource {
  Future<PhoneApiModel> createPhone(PhoneApiModel phone, {String? photoPath});
  Future<PhoneApiModel> getPhoneById(String id);
  Future<List<PhoneApiModel>> getAllPhones();
  Future<List<PhoneApiModel>> getPhonesBySeller();
  Future<List<PhoneApiModel>> getPhonesByBrand(String brandId);
  Future<List<PhoneApiModel>> getPhonesNearLocation(
    double lng,
    double lat, {
    double? maxDistance,
  });
  Future<PhoneApiModel> updatePhone(
    String id,
    PhoneApiModel phone, {
    String? photoPath,
  });
  Future<bool> deletePhone(String id);
}
