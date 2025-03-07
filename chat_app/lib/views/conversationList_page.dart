import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/conversation.dart';
import '../services/api_service.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Conversations")),
      body: FutureBuilder<List<Conversation>>(
        future: apiService.fetchConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune conversation trouvée.'));
          } else {
            final conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(conversation.participantName),
                  subtitle: Text(conversation.lastMessage ?? "Aucun message"),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: conversation.id, // Passer l'ID de la conversation
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await apiService.createConversation();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Conversation créée avec l'utilisateur test")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur: $e")),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
