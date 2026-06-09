import 'package:client/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
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
