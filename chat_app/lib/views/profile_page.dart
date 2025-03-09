import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return FutureBuilder(
      future: apiService.fetchUserDetails(), // Attendre la récupération des détails de l'utilisateur
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
              backgroundColor: Colors.white,
              elevation: 1,
              title: Text(
                'Profil',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueAccent[100],
                      child: Icon(
                        Icons.account_circle,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Section Nom
                  Text(
                    'Nom:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    apiService.name ?? "Nom inconnu",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  // Section Email
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    apiService.email ?? "Email inconnu",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await apiService.logout(); // Appelle la méthode de déconnexion
                        Navigator.pushReplacementNamed(context, '/login'); // Redirige vers la page de login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Bouton bleu
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 0, // Pas d'ombre pour un look plat
                      ),
                      child: Text(
                        'Se Déconnecter',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
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