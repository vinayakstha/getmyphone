// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['name'] = instance.name;
  val['image'] = instance.image;
  return val;
}
