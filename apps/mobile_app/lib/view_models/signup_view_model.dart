import 'package:flutter/material.dart';

class SignupViewModel with ChangeNotifier {
  // Controllers pour les champs du formulaire
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // État du formulaire
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Erreurs de validation
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;

  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get passwordError => _passwordError;

  // Méthode pour valider les champs
  bool _validateFields() {
    bool isValid = true;
    _firstNameError = null;
    _lastNameError = null;
    _emailError = null;
    _phoneError = null;
    _passwordError = null;

    if (firstNameController.text.isEmpty) {
      _firstNameError = "Le prénom est obligatoire";
      isValid = false;
    }

    if (lastNameController.text.isEmpty) {
      _lastNameError = "Le nom est obligatoire";
      isValid = false;
    }

    if (emailController.text.isEmpty) {
      _emailError = "L'email est obligatoire";
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      _emailError = "Email invalide";
      isValid = false;
    }

    if (phoneController.text.isEmpty) {
      _phoneError = "Le numéro de téléphone est obligatoire";
      isValid = false;
    } else if (!RegExp(r'^0[0-9]{9}$').hasMatch(phoneController.text)) {
      _phoneError = "Numéro de téléphone invalide";
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      _passwordError = "Le mot de passe est obligatoire";
      isValid = false;
    } else if (passwordController.text.length < 6) {
      _passwordError = "Le mot de passe est incorècte";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  // Méthode pour s'inscrire
  Future<void> signup(BuildContext context) async {
    if (!_validateFields()) return;

    _isLoading = true;
    notifyListeners();

    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 2));

    // Logique d'inscription ici (ex: appel à ton backend)
    // Exemple : if (email == "test" && password == "test") { ... }

    _isLoading = false;
    notifyListeners();

    // Redirection après inscription réussie
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  // Nettoyer les controllers
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
