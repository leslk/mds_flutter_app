import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Token {
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  static getIdFromToken(String token) async {
    var parts = token.split('.');
    var payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    const JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> tokenMap = decoder.convert(resp);
    var userData = tokenMap["data"];
    Map<String, dynamic> userDataMap = decoder.convert(userData);
    var id = userDataMap["id"];
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('id', id);
  }
}
