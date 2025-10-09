import 'package:flutter/material.dart';
import '../features/incidents/models/incident_model.dart';
import '/../services/incident_service.dart';

class IncidentViewModel with ChangeNotifier {
  final IncidentService _incidentService = IncidentService();

  // Controllers
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> submitIncident(String userId) async {
    if (!_validateForm()) return;

    isLoading = true;
    notifyListeners();

    final incident = CreateIncident(
      userId: userId,
      typeId: typeController.text.split(','),
      description: descriptionController.text,
      locationLatt: double.tryParse(latController.text) ?? 0,
      locationLong: double.tryParse(longController.text) ?? 0,
    );

    final result = await _incidentService.createIncident(incident);

    isLoading = false;

    if (result['success']) {
      successMessage = "✅ Incident créé avec succès";
      errorMessage = null;
      clearForm();
    } else {
      errorMessage = result['message'];
      successMessage = null;
    }

    notifyListeners();
  }

  bool _validateForm() {
    if (typeController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        latController.text.isEmpty ||
        longController.text.isEmpty) {
      errorMessage = "Tous les champs sont obligatoires";
      notifyListeners();
      return false;
    }
    return true;
  }

  void clearForm() {
    typeController.clear();
    descriptionController.clear();
    latController.clear();
    longController.clear();
  }
}
