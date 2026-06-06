import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final SharedPreferences _prefs;
  static const String _tokenKey = "auth_token";

  TokenService({required SharedPreferences prefs}) : _prefs = prefs;

  //save token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  // get token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
}
