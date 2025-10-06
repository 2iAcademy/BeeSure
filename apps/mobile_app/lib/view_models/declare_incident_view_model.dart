import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/incident_service.dart';

class DeclareIncidentViewModel extends ChangeNotifier {
  final IncidentService _incidentService = IncidentService();

  //GoogleMapController? mapController;
  //LatLng currentPosition = const LatLng(48.8566, 2.3522); // Paris par défaut

  String? selectedIncident;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Map<String, dynamic>> incidentTypes = [
    {"label": "Incendie", "icon": Icons.local_fire_department, "color": Colors.red},
    {"label": "Catastrophe", "icon": Icons.waves, "color": Colors.blueGrey},
    {"label": "Vol", "icon": Icons.person_outline, "color": Colors.purple},
    {"label": "Agression", "icon": Icons.warning_rounded, "color": Colors.orange},
    {"label": "Animal", "icon": Icons.pets, "color": Colors.green},
    {"label": "Armes", "icon": Icons.gavel, "color": Colors.grey},
    {"label": "Autre", "icon": Icons.error_outline, "color": Colors.amber},
  ];

  void selectIncident(String label) {
    selectedIncident = label;
    notifyListeners();
  }

  Future<void> submitIncident(BuildContext context) async {
    if (selectedIncident == null) return;

    _isLoading = true;
    notifyListeners();

    /*final result = await _incidentService.reportIncident(
      type: selectedIncident!,
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );*/

    _isLoading = false;
    notifyListeners();

    /*if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incident signalé avec succès')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Erreur inconnue')),
      );
    }*/
  }
}
