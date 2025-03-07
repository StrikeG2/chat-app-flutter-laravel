class Conversation {
  final int id;
  final int userId;
  final int participantId;
  final String participantName;
  final String? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.userId,
    required this.participantId,
    required this.participantName,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory pour créer une Conversation à partir d'un JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      userId: json['user_id'],
      participantId: json['participant_id'],
      participantName: json['participant']['name'], // Supposons que l'API retourne le participant
      lastMessage: json['messages'].isNotEmpty ? json['messages'].last['content'] : null,
      createdAt: DateTime.parse(json['created_at']), // Convertir la date de création
      updatedAt: DateTime.parse(json['updated_at']), // Convertir la date de mise à jour
    );
  }
}