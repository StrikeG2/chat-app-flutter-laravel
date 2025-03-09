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
      participantName: json['participant'] != null
          ? json['participant']['name'] ?? 'Nom inconnu'
          : 'Nom inconnu',  // Vérifier si 'participant' est présent
      lastMessage: (json['messages'] != null && json['messages'].isNotEmpty)
          ? json['messages'].last['content']
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),  // Valeur par défaut si la date est absente
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),  // Valeur par défaut si la date est absente
    );
  }
}
