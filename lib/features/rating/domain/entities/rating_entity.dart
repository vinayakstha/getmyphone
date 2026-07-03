import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final String? ratingId;
  final String raterId;
  final String targetId;
  final double score;
  final DateTime? createdAt;

  const RatingEntity({
    this.ratingId,
    required this.raterId,
    required this.targetId,
    required this.score,
    this.createdAt,
  });

  @override
  List<Object?> get props => [ratingId, raterId, targetId, score, createdAt];
}
