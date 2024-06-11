import 'package:mds_flutter_app/services/http_service.dart';
import 'package:mds_flutter_app/models/message.dart';

class Chat {
  int? id;
  int? characterId;
  List<Message> messages = [];

  Chat({
    required this.id,
    required this.characterId,
    //required this.messages,
  });

  factory Chat.fromJson(Map json) {
    return Chat(id: int.parse(json['id'].toString()), characterId: int.parse(json['character_id'].toString()));
  }

  Future<void> loadMessages() async {
    this.messages = await HttpService().getChatMessages(this.id!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character_id': characterId,
      'messages': messages,
    };
  }

  static Future<List<Chat>> getChats() async {
    return await HttpService().getChats();
  }

  static Future<Chat> createChat(int characterId) async {
    return await HttpService().createChat(characterId);
  }

  static Future<Chat> getChat(int id) async {
    return await HttpService().getChat(id);
  }

  Future<List<Message>> sendMessage(String content) async {
    List<Message> messages = await HttpService().sendMessage(this.id!, content);
    return messages;
  }

  static Future<void> deleteChat(int id) async {
    await HttpService().deleteChat(id);
  }

  static Future<Message> regenerateMessage(int id) async {
    return await HttpService().regenerateMessage(id);
  }
}
