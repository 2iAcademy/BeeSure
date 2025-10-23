import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/incidents/models/incident_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IncidentService {
  final String _baseUrl = dotenv.get('API_BASE_URL');

  Future<Map<String, dynamic>> createIncident(CreateIncident incident) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/incidents/create_incident'),
        headers: {
          'Content-Type': 'application/json',
        },
        body:incident.toJson(),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Erreur inconnue'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau: $e'};
    }
  }
}
