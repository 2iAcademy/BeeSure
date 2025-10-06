import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IncidentService {
  final String _baseUrl = dotenv.get('API_BASE_URL');

  Future<Map<String, dynamic>> reportIncident({
    required String type,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/incidents'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': type,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Erreur lors de l’envoi du signalement',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau : $e'};
    }
  }
}
