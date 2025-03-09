import 'package:chat_app/models/user_model.dart';

class Message {
  final int id;
  final int conversationId;
  final int userId;
  final String content;
  final User user;

  Message({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.content,
    required this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      userId: json['user_id'],
      content: json['content'],
      user: User.fromJson(json['user']), // Extraire l'objet User
    );
  }
}
