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
      create: (_) => ApiService(),
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
        '/': (context) => DefaultRoute(),
        '/login': (context) => LoginScreen(),
        '/chat': (context) => ChatPage(conversationId: 2,),
        '/register_page': (context) => RegisterScreen(),
        '/profile': (context) => ProfilePage(),
        '/searchUser': (context) => SearchUserPage(),
        '/conversation': (context) => ConversationListPage(),
      },
    );
  }
}

class DefaultRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return FutureBuilder(
      future: apiService.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return ConversationListPage();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
