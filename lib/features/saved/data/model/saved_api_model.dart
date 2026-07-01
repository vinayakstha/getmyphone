import 'package:client/features/phone/data/model/phone_api_model.dart';
import 'package:client/features/saved/domain/entities/saved_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class SavedApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String user;
  final PhoneApiModel phone;
  final DateTime? createdAt;

  SavedApiModel({
    this.id,
    required this.user,
    required this.phone,
    this.createdAt,
  });

  factory SavedApiModel.fromJson(Map<String, dynamic> json) =>
      _$SavedApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedApiModelToJson(this);

  SavedEntity toEntity() {
    return SavedEntity(
      savedId: id,
      userId: user,
      phone: phone.toEntity(),
      createdAt: createdAt,
    );
  }

  static List<SavedEntity> toEntityList(List<SavedApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
