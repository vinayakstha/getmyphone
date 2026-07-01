// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedApiModel _$SavedApiModelFromJson(Map<String, dynamic> json) =>
    SavedApiModel(
      id: json['_id'] as String?,
      user: json['user'] as String,
      phone: PhoneApiModel.fromJson(json['phone'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SavedApiModelToJson(SavedApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['user'] = instance.user;
  val['phone'] = instance.phone;
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
