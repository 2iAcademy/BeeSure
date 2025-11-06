import 'package:flutter/material.dart';
import '../features/incidents/models/incident_model.dart';
import '../features/enum/incident_type_enum.dart';
import '../services/incident_service.dart';
import '../views/success_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class IncidentViewModel with ChangeNotifier {
  final IncidentService _incidentService = IncidentService();
  // Controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  // ✅ Le type sélectionné avec ENUM
  IncidentTypeEnum? selectedType;

  // ✅ Étapes du formulaire
  int currentStep = 1;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // ✅ Sélection du type d’incident
  void selectIncidentType(IncidentTypeEnum type) {
    selectedType = type;
    notifyListeners();
  }

  // ✅ Navigation des étapes
  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      currentStep--;
      notifyListeners();
    }
  }

  // ✅ Réinitialisation
  void clearForm() {
    selectedType = null;
    descriptionController.clear();
    latController.clear();
    longController.clear();
    currentStep = 1;
    notifyListeners();
  }

  // ✅ Soumission
  Future<void> submitIncident(BuildContext context, String userId) async {
    if (selectedType == null) {
      errorMessage = "Veuillez choisir un type d'incident.";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    final typeIncident = [selectedType!.name][0];

    final incident = CreateIncident(
      userId: "d3d89823-4a77-46ca-94de-48e446c3cd51",
      typeId: typeIncident,
      description: descriptionController.text,
      locationLatt: 5.349391,
      locationLong: -4.008256,
    );

    final result = await _incidentService.createIncident(incident);
    isLoading = false;

    if (result['success']) {
      successMessage = "✅ Incident créé avec succès";
      errorMessage = null;
      clearForm();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage()),
      );
    } else {
      errorMessage = result['message'];
    }

    notifyListeners();
  }
}
