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
      appBar: AppBar(title: Text("Rechercher un utilisateur")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Rechercher un utilisateur",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchUsers, // Recherche seulement après le clic
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: searchResults.isEmpty
                  ? Center(child: Text("Aucun utilisateur trouvé."))
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  User user = searchResults[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: Icon(Icons.chat),
                      onPressed: () => createConversation(user),
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
