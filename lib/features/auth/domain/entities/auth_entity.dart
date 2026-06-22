import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? confirmPassword;
  final String? profilePicture;
  final double ratingAverage;
  final int ratingCount;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.confirmPassword,
    this.profilePicture,
    this.ratingAverage = 0,
    this.ratingCount = 0,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    phoneNumber,
    password,
    confirmPassword,
    profilePicture,
    ratingAverage,
    ratingCount,
  ];
}
