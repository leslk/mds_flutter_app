class Message {
  final int id;
  final String content;
  final bool isSentByHuman;
  final int conversationId;
  final String createdAt;

  Message({required this.id, required this.content, required this.isSentByHuman, required this.createdAt, required this.conversationId});

  factory Message.fromJson(Map json) {
    return Message(id: int.parse(json["id"].toString()), content: json["content"], isSentByHuman: json["is_sent_by_human"], conversationId: int.parse(json["conversation_id"].toString()), createdAt: json["created_at"]);
  }
}
