import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Token {
  /// Store the token in the shared preferences
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  /// Get the token from the shared preferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Remove the token from the shared preferences
  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// Get the id from the shared preferences
  static Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  /// Get the id from the token and store it in the shared preferences
  static getIdFromToken(String token) async {
    // Get the payload from the token
    var parts = token.split('.');
    // Get the payload
    var payload = parts[1];
    // Normalize the payload to base64
    var normalized = base64Url.normalize(payload);
    // Decode the payload
    var resp = utf8.decode(base64Url.decode(normalized));
    // Convert the payload to a map
    const JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> tokenMap = decoder.convert(resp);
    // Get the data from the payload
    var userData = tokenMap["data"];
    Map<String, dynamic> userDataMap = decoder.convert(userData);
    // Get the id from the data
    var id = userDataMap["id"];
    SharedPreferences sp = await SharedPreferences.getInstance();
    // Store the id in the shared preferences
    sp.setInt('id', id);
  }

  /// Check if the token is expired
  static bool isExpired(String token) {
    // Get the expiration date from the token
    var parts = token.split('.');
    // Get the payload
    var payload = parts[1];
    // Normalize the payload to base64
    var normalized = base64Url.normalize(payload);
    // Decode the payload
    var resp = utf8.decode(base64Url.decode(normalized));
    // Convert the payload to a map
    const JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> tokenMap = decoder.convert(resp);
    var exp = tokenMap["exp"];
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // return true if the token is expired
    return now > exp;
  }
}
