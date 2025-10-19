import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:http/http.dart' as http;

class AuthService {
  // final String _baseUrl = dotenv.get('API_BASE_URL'); // Remplace par ton URL d'API
  //final String? _apiKey = dotenv.get('API_KEY'); // Récupère la clé API depuis .env
  final String _baseUrl = (() {
    String? raw = dotenv.maybeGet('API_BASE_URL')?.trim();
    final bool useReverse = dotenv.maybeGet('USE_ADB_REVERSE') == '1';

    // Fallback si pas d'env
    if (raw == null || raw.isEmpty) {
      // Avec adb reverse actif, on reste sur localhost même sur Android
      if (defaultTargetPlatform == TargetPlatform.android && !useReverse) {
        return 'http://10.0.2.2:3000';
      }
      return 'http://localhost:3000';
    }

    // Si Android ET adb reverse désactivé -> remap localhost -> 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android && !useReverse) {
      final uri = Uri.parse(raw);
      if (uri.host == 'localhost' || uri.host == '127.0.0.1') {
        raw = uri.replace(host: '10.0.2.2').toString();
      }
    }

    if (raw.endsWith('/')) raw = raw.substring(0, raw.length - 1);
    return raw;
  })();

  // Méthode pour se connecter
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({'identifier': email, 'password': password}),
      );

      // Vérifie le statut de la réponse
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Échec de la connexion',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau : $e'};
    }
  }

  // Méthode pour s'inscrire (à utiliser dans SignupViewModel)
  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Échec de l\'inscription',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau : $e'};
    }
  }

  // Méthode pour sauvegarder le token (ex: dans SharedPreferences)
  Future<void> saveToken(String token) async {
    // Ici, tu peux utiliser shared_preferences pour stocker le token
    // Exemple :
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('auth_token', token);
  }

  // Méthode pour récupérer le token
  Future<String?> getToken() async {
    // Exemple :
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('auth_token');
    return null;
  }
}
