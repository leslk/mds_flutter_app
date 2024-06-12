import 'dart:convert';

import 'package:mds_flutter_app/services/http_service.dart';

class Universe {
  int? id;
  final String name;
  final String description;
  final String image;
  final int creatorId;

  Universe({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.creatorId,
  });

  static Universe fromJson(Map json) {
    return Universe(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      creatorId: json['creator_id'] ?? "",
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

  static Future<List<Universe>> getUniverses() async {
    return await HttpService().getUniverses();
  }

  static Future<Universe> getUniverse(int id) async {
    return await HttpService().getUniverse(id);
  }

  static Future<Universe> updateUniverse(int id, Map universeData) async {
    return await HttpService().updateUniverse(id, universeData);
  }

  static Future<Universe> createUniverse(Map universeData) async {
    return await HttpService().createUniverse(universeData);
  }
}
