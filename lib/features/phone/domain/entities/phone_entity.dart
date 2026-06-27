import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String type;
  final List<double> coordinates; // [lng, lat]

  const LocationEntity({this.type = "Point", required this.coordinates});

  @override
  List<Object?> get props => [type, coordinates];
}

class PhoneEntity extends Equatable {
  final String? phoneId;
  final String title;
  final String? photo;
  final String brand; // category id
  final String condition;
  final LocationEntity location;
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
  final String seller; // user id
  final DateTime? createdAt;

  const PhoneEntity({
    this.phoneId,
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

  @override
  List<Object?> get props => [
    phoneId,
    title,
    photo,
    brand,
    condition,
    location,
    description,
    cpu,
    storage,
    ram,
    screen,
    battery,
    camera,
    usedFor,
    negotiable,
    price,
    seller,
    createdAt,
  ];
}
