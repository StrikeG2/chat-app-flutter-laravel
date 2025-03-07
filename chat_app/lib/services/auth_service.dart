import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  int? _currentUserId;
  String? _token;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  int? get currentUserId => _currentUserId;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://votre-api-laravel.com/api/login'), // Remplacez par l'URL de votre API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _currentUserId = responseData['user']['id']; // Supposons que l'API retourne l'ID de l'utilisateur
      _token = responseData['access_token']; // Supposons que l'API retourne un token JWT
      await _storage.write(key: 'token', value: _token); // Stocker le token
      notifyListeners(); // Notifier les écrans que l'état a changé
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    _currentUserId = null;
    _token = null;
    await _storage.delete(key: 'token'); // Supprimer le token stocké
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      _token = token;
      // Vous pouvez également récupérer l'ID de l'utilisateur depuis le token ou une autre API
      notifyListeners();
    }
  }
}