// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationApiModel _$LocationApiModelFromJson(Map<String, dynamic> json) =>
    LocationApiModel(
      type: json['type'] as String? ?? "Point",
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$LocationApiModelToJson(LocationApiModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

PhoneApiModel _$PhoneApiModelFromJson(Map<String, dynamic> json) =>
    PhoneApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      photo: json['photo'] as String?,
      brand: json['brand'],
      condition: json['condition'] as String,
      location:
          LocationApiModel.fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String,
      cpu: json['cpu'] as String,
      storage: json['storage'] as String,
      ram: json['ram'] as String,
      screen: json['screen'] as String,
      battery: json['battery'] as String,
      camera: json['camera'] as String,
      usedFor: json['usedFor'] as String,
      negotiable: json['negotiable'] as String,
      price: (json['price'] as num).toDouble(),
      seller: json['seller'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PhoneApiModelToJson(PhoneApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['title'] = instance.title;
  writeNotNull('photo', instance.photo);
  writeNotNull('brand', instance.brand);
  val['condition'] = instance.condition;
  val['location'] = instance.location;
  val['description'] = instance.description;
  val['cpu'] = instance.cpu;
  val['storage'] = instance.storage;
  val['ram'] = instance.ram;
  val['screen'] = instance.screen;
  val['battery'] = instance.battery;
  val['camera'] = instance.camera;
  val['usedFor'] = instance.usedFor;
  val['negotiable'] = instance.negotiable;
  val['price'] = instance.price;
  writeNotNull('seller', instance.seller);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
