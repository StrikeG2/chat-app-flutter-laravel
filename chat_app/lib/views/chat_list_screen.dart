import 'package:flutter/material.dart';

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversations")),
      body: ListView.builder(
        itemCount: 10, // Remplacer par des données dynamiques
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("Utilisateur $index"),
            subtitle: Text("Dernier message..."),
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
          );
        },
      ),
    );
  }
}
