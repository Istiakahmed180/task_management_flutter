import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/screens/sign_in/model/login_model.dart';

class AuthController {
  final String _accessTokenKey = "access_token";
  final String _userDataKey = "user_data";

  static String? accessToken;
  static UserModel? userData;

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    accessToken = token;
  }

  Future<void> saveUserInfo(UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userModel.toJson()));
    userData = userModel;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessTokenKey);
    return accessToken;
  }

  Future<UserModel?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEncodedData = prefs.getString(_userDataKey);
    if (userEncodedData == null) {
      return null;
    }
    UserModel userModel = UserModel.fromJson(jsonDecode(userEncodedData));
    userData = userModel;
    return userModel;
  }

  bool get isLoggedIn => accessToken != null;

  Future<void> clearSharedPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
  }
}
