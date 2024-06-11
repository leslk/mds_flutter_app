import 'dart:convert';

import 'package:mds_flutter_app/services/http_service.dart';

class User {
  int? id;
  final String email;
  final String firstname;
  final String lastname;
  final String username;

  User({
    this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.username,
  });

  static User fromJson(Map json) {
    // TODO: Implémenter une gestion d'erreur plus fine
    return User(
      id: int.parse(json['id'].toString()),
      email: json['email'] ?? "",
      firstname: json['firstname'] ?? "",
      lastname: json['lastname'] ?? "",
      username: json['username'] ?? "",
    );
  }

  String toJson() {
    return jsonEncode({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
    });
  }

  static Future<void> login(String username, String password) async {
    await HttpService().login(username, password);
  }

  static Future<void> signup(
    String pseudo,
    String lastname,
    String firstName,
    String email,
    String password,
  ) async {
    Map user = {
      'id': '',
      'email': email,
      'firstname': firstName,
      'lastname': lastname,
      'username': pseudo,
      'password': password,
    };
    await HttpService().signup(user);
  }

  static Future<List<User>> getUsers() async {
    return await HttpService().getUsers();
  }

  static Future<User> getUser(int id) async {
    return await HttpService().getUser(id);
  }

  static Future<User> updateUser(int id, Map<String, dynamic> userData) async {
    return await HttpService().updateUser(id, userData);
  }
}
