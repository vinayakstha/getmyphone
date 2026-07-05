import 'package:client/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, loaded, updated, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final AuthEntity? user;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    AuthEntity? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
