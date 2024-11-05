import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network_response.dart';

class NetworkService {
  // Common request timeout duration
  static const Duration timeoutDuration = Duration(seconds: 15);

  // Get Token from SharedPreferences
  static Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Request Headers
  static Map<String, String> _requestHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['token'] = token;
    }

    return headers;
  }

  // Get API Network Service
  static Future<NetworkResponse> getRequest({required String url}) async {
    final String? token = await _getToken();
    try {
      Uri uri = Uri.parse(url);
      final response = await get(uri, headers: _requestHeaders(token))
          .timeout(timeoutDuration);
      return _handleResponse(url, response, token);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Post API Network Service
  static Future<NetworkResponse> postRequest({
    required String url,
    required Map<String, dynamic> requestBody,
  }) async {
    final String? token = await _getToken();
    try {
      Uri uri = Uri.parse(url);
      debugPrint("Request Body: ${jsonEncode(requestBody)}");
      final response = await post(
        uri,
        headers: _requestHeaders(token),
        body: jsonEncode(requestBody),
      ).timeout(timeoutDuration);
      return _handleResponse(url, response, token);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Common function to handle API responses
  static NetworkResponse _handleResponse(
      String url, Response response, String? token) {
    printResponse(url, response, token);

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      try {
        final jsonResponse = jsonDecode(response.body);
        final status = jsonResponse["status"];

        if (status == "success") {
          return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            requestResponse: jsonResponse,
          );
        } else if (status == "fail") {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: jsonResponse["data"] ?? "An error occurred",
          );
        } else {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: "Unexpected status value: $status",
          );
        }
      } catch (e) {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Invalid JSON format",
        );
      }
    } else {
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: "Request failed with status: ${response.statusCode}",
      );
    }
  }

  // Common function to handle errors
  static NetworkResponse _handleError(dynamic error) {
    return NetworkResponse(
      isSuccess: false,
      statusCode: -1,
      errorMessage: error is TimeoutException
          ? "Request timed out after ${timeoutDuration.inSeconds} seconds. Please check your connection and try again."
          : "An error occurred: ${error.toString()}",
    );
  }

  // Logging the API responses for debugging
  static void printResponse(String url, Response response, String? token) {
    debugPrint(
        "URL : $url\nResponse Code : ${response.statusCode}\nToken : $token\nResponse Body : ${response.body}");
  }
}
