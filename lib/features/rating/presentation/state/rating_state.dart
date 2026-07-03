import 'package:client/features/rating/domain/entities/rating_entity.dart';
import 'package:equatable/equatable.dart';

enum RatingStatus { initial, loading, submitted, loaded, error }

class RatingState extends Equatable {
  final RatingStatus status;
  final List<RatingEntity> ratings;
  final String? errorMessage;

  const RatingState({
    this.status = RatingStatus.initial,
    this.ratings = const [],
    this.errorMessage,
  });

  RatingState copyWith({
    RatingStatus? status,
    List<RatingEntity>? ratings,
    String? errorMessage,
  }) {
    return RatingState(
      status: status ?? this.status,
      ratings: ratings ?? this.ratings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ratings, errorMessage];
}
