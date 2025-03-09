import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  List<User> searchResults = [];
  bool isLoading = false;

  // Recherche des utilisateurs uniquement après le clic sur le bouton
  void searchUsers() async {
    if (searchController.text.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<User> results = await apiService.searchUsers(searchController.text);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erreur: $e");
    }
  }

  void createConversation(User user) async {
    try {
      await apiService.createConversationWithUser(user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Conversation avec ${user.name} créée !")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de la création de la conversation")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar blanche
        elevation: 1, // Légère ombre pour la séparation
        title: Text(
          "Rechercher un utilisateur",
          style: TextStyle(
            color: Colors.black87, // Texte en noir
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centrer le titre
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Rechercher un utilisateur",
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.blueAccent), // Icône de recherche en bleu
                  onPressed: searchUsers, // Recherche seulement après le clic
                ),
              ),
            ),
            SizedBox(height: 20),
            // Résultats de la recherche
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: searchResults.isEmpty
                  ? Center(
                child: Text(
                  "Aucun utilisateur trouvé.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  User user = searchResults[index];
                  return Card(
                    elevation: 0, // Pas d'ombre pour un look plat
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent[100], // Fond bleu clair
                        child: Icon(Icons.person, color: Colors.white), // Icône de personne
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.chat, color: Colors.blueAccent), // Icône de chat en bleu
                        onPressed: () => createConversation(user),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}