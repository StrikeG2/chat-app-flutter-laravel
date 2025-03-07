import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';


class ChatPage extends StatefulWidget {
  final int conversationId;

  ChatPage({required this.conversationId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final conversationId = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: Text("Conversation ${widget.conversationId}")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: apiService.fetchMessages(widget.conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun message trouvé.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(
                        message: message.content,
                        isMe: message.userId == Provider.of<AuthService>(context).currentUserId,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await apiService.sendMessage(
                        widget.conversationId,
                        _messageController.text,
                      );
                      _messageController.clear();
                      setState(() {}); // Rafraîchir l'écran
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}