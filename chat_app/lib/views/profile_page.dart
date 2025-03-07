import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return FutureBuilder(
      future: apiService.fetchUserDetails(),  // Attendre la récupération des détails de l'utilisateur
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (apiService.name == null || apiService.email == null) {
          return Center(child: Text('Aucun utilisateur trouvé.'));
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.greenAccent,
              title: Text('Profil Utilisateur'),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.account_circle, size: 90, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Nom:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    apiService.name ?? "Nom inconnu",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    apiService.email ?? "Email inconnu",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour la déconnexion ou une autre action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text('Se Déconnecter', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
