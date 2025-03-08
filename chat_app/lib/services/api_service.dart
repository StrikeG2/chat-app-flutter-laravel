import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/conversation.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final FlutterSecureStorage storage = FlutterSecureStorage();

  int? _currentUserId;
  String? _token;
  String? _name;
  String? _email;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  int? get currentUserId => _currentUserId;
  String? get token => _token;
  String? get name => _name;
  String? get email => _email;

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> setToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<dynamic> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> fetchUserDetails() async {
    final token = await getToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/user'), //
        headers: {
          'Authorization': 'Bearer $token', // Passe le token dans les headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUserId = data['id'];
        _name = data['name'];
        _email = data['email'];
      } else {
        throw Exception('Échec de la récupération des détails de l\'utilisateur');
      }
    }
  }

  Future<List<Conversation>> fetchConversations() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'), // Assure-toi que l'URL est correcte
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic decodedResponse = json.decode(response.body);

      if (decodedResponse is List) {
        return decodedResponse.map((json) => Conversation.fromJson(json)).toList();
      } else if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
        return (decodedResponse['data'] as List)
            .map((json) => Conversation.fromJson(json))
            .toList();
      } else {
        throw Exception('Format de réponse inattendu');
      }
    } else {
      throw Exception('Failed to load conversations');
    }
  }


  Future<void> createConversationWithUser(int userId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'participant_id': userId}),
    );

    if (response.statusCode == 201) {
      print("Conversation créée avec succès !");
    } else {
      throw Exception('Échec de la création de la conversation');
    }
  }


  Future<List<Message>> fetchMessages(int conversationId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$conversationId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    print("Réponse de l'API pour fetchMessages: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);  // 🔄 C'est une liste, pas un Map !
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(int conversationId, String content) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'conversation_id': conversationId,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      // Message envoyé avec succès
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<List<User>> searchUsers(String query) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/search?query=${Uri.encodeComponent(query)}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Réponse de l'API: $data");

      if (data.isNotEmpty) {
        List<User> users = [User.fromJson(data)];
        return users;
      } else {
        throw Exception('Aucun utilisateur trouvé');
      }
    } else {
      throw Exception('Échec de la recherche des utilisateurs');
    }
  }

  Future<User> fetchConversationUser(int conversationId) async {
    final response = await http.get(Uri.parse('$baseUrl/conversations/$conversationId/user'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data); // Transforme la réponse en objet User
    } else {
      throw Exception('Erreur lors de la récupération de l\'utilisateur');
    }
  }

}