import 'package:client/features/phone/domain/entities/phone_entity.dart';
import 'package:equatable/equatable.dart';

enum CategoryPhoneStatus { initial, loading, loaded, error }

class CategoryPhoneState extends Equatable {
  final CategoryPhoneStatus status;
  final List<PhoneEntity> phones;
  final String? errorMessage;

  const CategoryPhoneState({
    this.status = CategoryPhoneStatus.initial,
    this.phones = const [],
    this.errorMessage,
  });

  CategoryPhoneState copyWith({
    CategoryPhoneStatus? status,
    List<PhoneEntity>? phones,
    String? errorMessage,
  }) {
    return CategoryPhoneState(
      status: status ?? this.status,
      phones: phones ?? this.phones,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, phones, errorMessage];
}
