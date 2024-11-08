import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String _accessTokenKey = "access_token";
  final String _email = "user_email";
  final String _firstName = "user_first_name";
  final String _lastName = "user_last_name";

  static String? accessToken;
  static Map<String, String>? userInfo;

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    accessToken = token;
  }

  Future<void> saveUserInfo(
      String email, String firstName, String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, email);
    await prefs.setString(_firstName, firstName);
    await prefs.setString(_lastName, lastName);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessTokenKey);
    return accessToken;
  }

  Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString(_email) ?? "";
    String firstName = prefs.getString(_firstName) ?? "";
    String lastName = prefs.getString(_lastName) ?? "";

    Map<String, String> userInformation = {
      "email": email,
      "userName":
          "${firstName.isNotEmpty ? firstName : ""} ${lastName.isNotEmpty ? lastName : ""}",
    };

    return userInfo = userInformation;
  }

  bool get isLoggedIn => accessToken != null;

  Future<void> clearSharedPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
  }
}
