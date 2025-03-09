import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/conversation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    final currentUserId = apiService.currentUserId; // ID de l'utilisateur connecté

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Conversations',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black87),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Conversation>>(
        future: apiService.fetchConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune conversation trouvée.'));
          } else {
            final conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];

                // Identifier l'autre participant en utilisant participantId
                final isCurrentUser = conversation.userId == currentUserId;
                final otherParticipantId = isCurrentUser ? conversation.participantId : conversation.userId;

                return FutureBuilder<User>(
                  future: apiService.fetchConversationUser(conversation.id),
                  builder: (context, participantSnapshot) {
                    if (participantSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (participantSnapshot.hasError) {
                      print("Erreur de récupération du participant: ${participantSnapshot.error}");
                      return Center(child: Text('Erreur de récupération du participant'));
                    } else if (!participantSnapshot.hasData) {
                      return const SizedBox(); // Si aucun participant trouvé
                    } else {
                      final participant = participantSnapshot.data!;
                      final participantName = participant.name ?? "Nom inconnu";

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent[100], // Fond bleu clair
                          child: const Icon(Icons.person, color: Colors.white), // Icône de personne
                        ),
                        title: Text(
                          participantName, // Utilise le nom du participant
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          conversation.lastMessage ?? "Aucun message", // Utilise une valeur par défaut si lastMessage est null
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: conversation.id, // Passe l'ID de la conversation
                          );
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/searchUser'); // Navigue vers la page de recherche
        },
        backgroundColor: Colors.blueAccent, // Bouton bleu
        child: const Icon(Icons.add, color: Colors.white), // Icône d'ajout
      ),
    );
  }
}