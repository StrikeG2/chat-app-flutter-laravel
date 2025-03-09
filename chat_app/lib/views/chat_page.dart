import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class ChatPage extends StatefulWidget {
  final int conversationId;

  ChatPage({required this.conversationId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ApiService apiService = ApiService();
  String userName = '';
  int? currentUserId; // Stocker l'ID de l'utilisateur connecté

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await apiService.fetchUserDetails(); // Récupérer les infos utilisateur
    setState(() {
      currentUserId = apiService.currentUserId; // Assigner l'ID utilisateur
    });
    _fetchConversationDetails();
  }

  Future<void> _fetchConversationDetails() async {
    try {
      final user = await apiService.fetchConversationUser(widget.conversationId);
      setState(() {
        userName = user.name;
      });
    } catch (e) {
      print("Erreur lors de la récupération des détails de la conversation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc pour un design épuré
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar blanche
        elevation: 1, // Légère ombre pour la séparation
        title: Text(
          userName.isEmpty ? 'Chargement...' : 'Conversation avec $userName',
          style: TextStyle(
            color: Colors.black87, // Texte en noir
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87), // Icône de retour en noir
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Zone de messages
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
                    reverse: true, // Afficher les messages du plus récent au plus ancien
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(
                        message: message.content,
                        isMe: message.userId == currentUserId,
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Zone de saisie de message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Champ de texte pour saisir le message
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre message...',
                      filled: true,
                      fillColor: Colors.grey[100], // Fond gris clair
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                // Bouton d'envoi
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent), // Icône d'envoi en bleu
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await apiService.sendMessage(
                        widget.conversationId,
                        _messageController.text,
                      );
                      _messageController.clear();
                      setState(() {});
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

// Widget pour afficher une bulle de message
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300], // Couleur bleue pour les messages de l'utilisateur
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87, // Texte blanc pour les messages de l'utilisateur
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}