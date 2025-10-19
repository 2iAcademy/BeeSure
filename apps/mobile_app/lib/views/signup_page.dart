import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/signup_view_model.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    const beeYellow = Color(0xFFFFB624);
    const beeDark = Color(0xFF1F1F1F);

    InputDecoration _beeOutline(
      String label, {
      String? errorText,
      IconData? icon,
    }) {
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: beeYellow, width: 2),
      );
      final errorBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      );
      return InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: icon != null ? Icon(icon, color: beeDark) : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        filled: false, // pas de fond, juste le contour
        enabledBorder: border,
        focusedBorder: border,
        border: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      );
    }

    final primaryBtnStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: beeYellow,
      foregroundColor: Colors.black87,
      elevation: 2,
      shadowColor: const Color(0x33000000),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(''), // flèche retour uniquement
          iconTheme: const IconThemeData(color: beeDark),
        ),
        body: Consumer<SignupViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Inscription",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: beeDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Rejoignez-nous",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),

                  // Prénom
                  TextFormField(
                    controller: viewModel.firstNameController,
                    textInputAction: TextInputAction.next,
                    decoration: _beeOutline(
                      "Prénom*",
                      errorText: viewModel.firstNameError,
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nom
                  TextFormField(
                    controller: viewModel.lastNameController,
                    textInputAction: TextInputAction.next,
                    decoration: _beeOutline(
                      "Nom*",
                      errorText: viewModel.lastNameError,
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: viewModel.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _beeOutline(
                      "Email*",
                      errorText: viewModel.emailError,
                      icon: Icons.email,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Téléphone
                  TextFormField(
                    controller: viewModel.phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: _beeOutline(
                      "Numéro de téléphone*",
                      errorText: viewModel.phoneError,
                      icon: Icons.phone,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mot de passe
                  TextFormField(
                    controller: viewModel.passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: _beeOutline(
                      "Mot de passe*",
                      errorText: viewModel.passwordError,
                      icon: Icons.lock,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (viewModel.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: primaryBtnStyle,
                        onPressed: () => viewModel.signup(context),
                        child: const Text("CRÉER MON COMPTE"),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
