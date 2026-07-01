import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:equatable/equatable.dart';

enum PhoneStatus { initial, loading, loaded, created, updated, deleted, error }

class PhoneState extends Equatable {
  final PhoneStatus status;
  final List<PhoneEntity> phones;
  final PhoneEntity? selectedPhone;
  final String? errorMessage;

  const PhoneState({
    this.status = PhoneStatus.initial,
    this.phones = const [],
    this.selectedPhone,
    this.errorMessage,
  });

  PhoneState copyWith({
    PhoneStatus? status,
    List<PhoneEntity>? phones,
    PhoneEntity? selectedPhone,
    String? errorMessage,
  }) {
    return PhoneState(
      status: status ?? this.status,
      phones: phones ?? this.phones,
      selectedPhone: selectedPhone ?? this.selectedPhone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phones, selectedPhone, errorMessage];
}
