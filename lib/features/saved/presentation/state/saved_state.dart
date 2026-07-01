import 'package:client/features/saved/domain/entities/saved_entity.dart';
import 'package:equatable/equatable.dart';

enum SavedStatus { initial, loading, loaded, toggled, error }

class SavedState extends Equatable {
  final SavedStatus status;
  final List<SavedEntity> savedListings;
  final bool? isSaved;
  final String? errorMessage;

  const SavedState({
    this.status = SavedStatus.initial,
    this.savedListings = const [],
    this.isSaved,
    this.errorMessage,
  });

  SavedState copyWith({
    SavedStatus? status,
    List<SavedEntity>? savedListings,
    bool? isSaved,
    String? errorMessage,
  }) {
    return SavedState(
      status: status ?? this.status,
      savedListings: savedListings ?? this.savedListings,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, savedListings, isSaved, errorMessage];
}
