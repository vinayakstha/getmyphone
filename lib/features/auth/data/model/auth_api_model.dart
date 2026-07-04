import 'package:client/features/auth/domain/entities/auth_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? confirmPassword;
  final String? profilePicture;
  final double ratingAverage;
  final int ratingCount;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.confirmPassword,
    this.profilePicture,
    this.ratingAverage = 0,
    this.ratingCount = 0,
  });

  // manually parse nested rating object
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map<String, dynamic>?;
    return AuthApiModel(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String? ?? '',
      confirmPassword: json['confirmPassword'] as String?,
      profilePicture: json['profilePicture'] as String?,
      ratingAverage: (rating?['average'] as num?)?.toDouble() ?? 0,
      ratingCount: (rating?['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
      ratingAverage: ratingAverage,
      ratingCount: ratingCount,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      ratingAverage: entity.ratingAverage,
      ratingCount: entity.ratingCount,
    );
  }
}
