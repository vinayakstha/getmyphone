import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class LocationApiModel {
  final String type;
  final List<double> coordinates;

  LocationApiModel({this.type = "Point", required this.coordinates});

  factory LocationApiModel.fromJson(Map<String, dynamic> json) =>
      _$LocationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationApiModelToJson(this);

  LocationEntity toEntity() {
    return LocationEntity(type: type, coordinates: coordinates);
  }

  factory LocationApiModel.fromEntity(LocationEntity entity) {
    return LocationApiModel(type: entity.type, coordinates: entity.coordinates);
  }
}

@JsonSerializable(includeIfNull: false)
class PhoneApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String? photo;
  final dynamic brand; // can be String id or Map when populated
  final String condition;
  final LocationApiModel location;
  final String description;
  final String cpu;
  final String storage;
  final String ram;
  final String screen;
  final String battery;
  final String camera;
  final String usedFor;
  final String negotiable;
  final double price;
  final dynamic seller; // can be String id or Map when populated
  final DateTime? createdAt;

  PhoneApiModel({
    this.id,
    required this.title,
    this.photo,
    required this.brand,
    required this.condition,
    required this.location,
    required this.description,
    required this.cpu,
    required this.storage,
    required this.ram,
    required this.screen,
    required this.battery,
    required this.camera,
    required this.usedFor,
    required this.negotiable,
    required this.price,
    required this.seller,
    this.createdAt,
  });

  factory PhoneApiModel.fromJson(Map<String, dynamic> json) =>
      _$PhoneApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneApiModelToJson(this);

  PhoneEntity toEntity() {
    return PhoneEntity(
      phoneId: id,
      title: title,
      photo: photo,
      brand: brand is Map ? brand['_id'] as String : brand as String,
      condition: condition,
      location: location.toEntity(),
      description: description,
      cpu: cpu,
      storage: storage,
      ram: ram,
      screen: screen,
      battery: battery,
      camera: camera,
      usedFor: usedFor,
      negotiable: negotiable,
      price: price,
      seller: seller is Map ? seller['_id'] as String : seller as String,
      createdAt: createdAt,
    );
  }

  factory PhoneApiModel.fromEntity(PhoneEntity entity) {
    return PhoneApiModel(
      id: entity.phoneId,
      title: entity.title,
      photo: entity.photo,
      brand: entity.brand,
      condition: entity.condition,
      location: LocationApiModel.fromEntity(entity.location),
      description: entity.description,
      cpu: entity.cpu,
      storage: entity.storage,
      ram: entity.ram,
      screen: entity.screen,
      battery: entity.battery,
      camera: entity.camera,
      usedFor: entity.usedFor,
      negotiable: entity.negotiable,
      price: entity.price,
      seller: entity.seller,
      createdAt: entity.createdAt,
    );
  }

  static List<PhoneEntity> toEntityList(List<PhoneApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
