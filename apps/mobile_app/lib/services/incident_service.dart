import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/incidents/models/incident_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IncidentService {
  final String _baseUrl = dotenv.get('API_BASE_URL');
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> createIncident(CreateIncident incident) async {
    print("✅ Incident envoyé au backend : ${jsonEncode(incident.toJson())}");

    try {

      final token = await _storage.read(key: 'accessToken');
      print("🔑 Token : $token");

      if (token == null) {
        return {'success': false, 'message': 'Token manquant. Veuillez vous reconnecter.'};
      }
      print("je suis dans le try !");
      final response = await http.post(
        Uri.parse('$_baseUrl/incidents/create_incident'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body:jsonEncode(incident.toJson()),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Erreur inconnue'};
      }
    } catch (e) {
      print("j'ai un problème avec le try ! Erreur : " + e.toString());
      return {'success': false, 'message': 'Erreur réseau: $e'};
    }
  }
}
