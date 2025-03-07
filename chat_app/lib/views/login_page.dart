import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: Text(
          'Se connecter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Text(
              'Connexion à votre compte',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            // Champ Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Champ Mot de passe
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32),
            // Bouton Se connecter
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                try {
                  final response = await Provider.of<ApiService>(context, listen: false).login(
                    emailController.text,
                    passwordController.text,
                  );
                  await Provider.of<ApiService>(context, listen: false).setToken(response['access_token']);
                  Navigator.pushReplacementNamed(context, '/');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Échec de la connexion: $e')),
                  );
                }
              },
              child: Text(
                'Se connecter',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            // Lien vers la page d'inscription
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register_page');
                },
                child: Text(
                  "Créer un compte",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
