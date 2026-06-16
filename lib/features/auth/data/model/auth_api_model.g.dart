// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String?,
      profilePicture: json['profilePicture'] as String?,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['fullName'] = instance.fullName;
  val['email'] = instance.email;
  val['phoneNumber'] = instance.phoneNumber;
  val['password'] = instance.password;
  writeNotNull('confirmPassword', instance.confirmPassword);
  writeNotNull('profilePicture', instance.profilePicture);
  val['ratingAverage'] = instance.ratingAverage;
  val['ratingCount'] = instance.ratingCount;
  return val;
}
