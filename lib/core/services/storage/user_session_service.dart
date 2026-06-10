import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    "SharedPreferences has not been initialized. Initialize it in main.dart",
  );
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserProfilePicture = 'user_profile_picture';
  static const String _keyToken = 'token';
  static const String _keyUserRatingAverage = 'user_rating_average';
  static const String _keyUserRatingCount = 'user_rating_count';

  // save session
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    required String phoneNumber,
    String? profilePicture,
    double ratingAverage = 0,
    int ratingCount = 0,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);
    await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    await _prefs.setDouble(_keyUserRatingAverage, ratingAverage);
    await _prefs.setInt(_keyUserRatingCount, ratingCount);
    if (profilePicture != null) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture);
    }
  }

  // clear session
  Future<void> clearUserSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserProfilePicture);
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUserRatingAverage);
    await _prefs.remove(_keyUserRatingCount);
  }

  // update profile picture
  Future<void> updateProfilePicture(String profilePicture) async {
    await _prefs.setString(_keyUserProfilePicture, profilePicture);
  }

  // update rating
  Future<void> updateRating(double average, int count) async {
    await _prefs.setDouble(_keyUserRatingAverage, average);
    await _prefs.setInt(_keyUserRatingCount, count);
  }

  // getters
  bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;
  String? getUserId() => _prefs.getString(_keyUserId);
  String? getUserEmail() => _prefs.getString(_keyUserEmail);
  String? getUserFullName() => _prefs.getString(_keyUserFullName);
  String? getUserPhoneNumber() => _prefs.getString(_keyUserPhoneNumber);
  String? getUserProfilePicture() => _prefs.getString(_keyUserProfilePicture);
  String? getToken() => _prefs.getString(_keyToken);
  double getUserRatingAverage() => _prefs.getDouble(_keyUserRatingAverage) ?? 0;
  int getUserRatingCount() => _prefs.getInt(_keyUserRatingCount) ?? 0;
}
