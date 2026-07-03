import 'package:client/features/rating/domain/entities/rating_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class RatingApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String raterId;
  final String targetId;
  final double score;
  final DateTime? createdAt;

  RatingApiModel({
    this.id,
    required this.raterId,
    required this.targetId,
    required this.score,
    this.createdAt,
  });

  factory RatingApiModel.fromJson(Map<String, dynamic> json) =>
      _$RatingApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingApiModelToJson(this);

  RatingEntity toEntity() {
    return RatingEntity(
      ratingId: id,
      raterId: raterId,
      targetId: targetId,
      score: score,
      createdAt: createdAt,
    );
  }

  static List<RatingEntity> toEntityList(List<RatingApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
