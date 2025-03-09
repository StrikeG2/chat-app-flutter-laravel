import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'views/chat_page.dart';
import 'views/profile_page.dart';
import 'views/register_page.dart';
import 'views/search_user_page.dart';
import 'views/conversationList_page.dart';
import 'views/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ApiService(), // Fournisseur de ApiService
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => DefaultRoute(), // Page par défaut
        '/login': (context) => LoginScreen(), // Page de connexion
        '/chat': (context) => ChatPage(conversationId: 2,), // Définir la page de chat
        '/register_page': (context) => RegisterScreen(), // Page d'inscription
        '/profile': (context) => ProfilePage(), // Page de profil
        '/searchUser': (context) => SearchUserPage(), // Page de recherche d'utilisateurs
        '/conversation': (context) => ConversationListPage(), // Page des conversations
      },
    );
  }
}

class DefaultRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    // Vérification du token dès l'ouverture de l'app
    return FutureBuilder(
      future: apiService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant la vérification
          return Center(child: CircularProgressIndicator());
        }

        // Si un token est trouvé, rediriger vers la page des conversations
        if (snapshot.hasData && snapshot.data != null) {
          return ConversationListPage();
        } else {
          // Si aucun token n'est trouvé, rediriger vers la page de connexion
          return LoginScreen();
        }
      },
    );
  }
}
