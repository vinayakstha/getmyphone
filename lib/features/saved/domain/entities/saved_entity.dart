import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:equatable/equatable.dart';

class SavedEntity extends Equatable {
  final String? savedId;
  final String userId;
  final PhoneEntity phone;
  final DateTime? createdAt;

  const SavedEntity({
    this.savedId,
    required this.userId,
    required this.phone,
    this.createdAt,
  });

  @override
  List<Object?> get props => [savedId, userId, phone, createdAt];
}
