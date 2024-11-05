import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String _accessTokenKey = "access_token";

  static String? accessToken;

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    accessToken = token;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessTokenKey);
    return accessToken;
  }

  bool get isLoggedIn => accessToken != null;

  Future<void> clearSharedPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
  }
}
