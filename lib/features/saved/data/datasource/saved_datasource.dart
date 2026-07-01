import 'package:client/features/saved/data/model/saved_api_model.dart';

abstract interface class ISavedRemoteDataSource {
  Future<Map<String, dynamic>> toggleSave(String phoneId);
  Future<List<SavedApiModel>> getSavedByUser();
  Future<bool> isSaved(String phoneId);
}
