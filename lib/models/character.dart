import 'dart:convert';

import 'package:mds_flutter_app/services/http_service.dart';

class Character {
  int? id;
  final String name;
  final String description;
  final String image;
  int? creatorId;

  Character({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.creatorId,
  });

  static Character fromJson(Map json) {
    return Character(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      creatorId: int.parse(json['creator_id'].toString()),
    );
  }

  String toJson() {
    return jsonEncode({
      'name': name,
      'description': description,
      'image': image,
      'creator_id': creatorId,
    });
  }

  static Future<List<Character>> getCharacters(int universeId) async {
    return await HttpService().getCharacters(universeId);
  }

  static Future<Character> getCharacter(int id) async {
    return await HttpService().getCharacter(id);
  }

  static Future<Character> updateCharacter(int universeId, Map characterData) async {
    return await HttpService().updateCharacter(universeId, characterData);
  }

  static Future<String> deleteCharacter(int id) async {
    return await HttpService().deleteCharacter(id);
  }

  static Future<Character> createCharacter(int universeId, Map characterData) async {
    return await HttpService().createCharacter(universeId, characterData);
  }
}
