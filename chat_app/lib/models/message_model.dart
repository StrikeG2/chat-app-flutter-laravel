class Message {
  final int id;
  final String content;
  final String sender;

  Message({required this.id, required this.content, required this.sender});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      sender: json['sender'],
    );
  }
}