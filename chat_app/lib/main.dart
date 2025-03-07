import 'package:chat_app/views/chat_page.dart';
import 'package:chat_app/views/profile_page.dart';
import 'package:chat_app/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'views/conversationList_page.dart';
import 'views/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => ApiService()),
      ],
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
        '/': (context) => ConversationListPage(), // Page principale après connexion
        '/login': (context) => LoginScreen(), // Page de connexion
        '/chat': (context) => ChatPage(conversationId: 2,),  // Définir la page de chat
        '/register_page': (context) => RegisterScreen(),  // Définir la page de chat
        '/profile': (context) => ProfilePage(),  // Définir la page de chat

      },
    );
  }
}