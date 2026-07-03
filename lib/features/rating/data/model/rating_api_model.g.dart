// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingApiModel _$RatingApiModelFromJson(Map<String, dynamic> json) =>
    RatingApiModel(
      id: json['_id'] as String?,
      raterId: json['raterId'] as String,
      targetId: json['targetId'] as String,
      score: (json['score'] as num).toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RatingApiModelToJson(RatingApiModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['raterId'] = instance.raterId;
  val['targetId'] = instance.targetId;
  val['score'] = instance.score;
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
