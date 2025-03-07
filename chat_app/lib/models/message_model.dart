class Message {
  final int id;
  final int conversationId;
  final int userId;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  // Factory pour créer un Message à partir d'un JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}