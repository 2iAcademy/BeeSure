import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
        filled: false, // pas de fond, uniquement contour
        enabledBorder: border,
        focusedBorder: border,
        border: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      );
    }

    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      "Content de te revoir",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: beeDark,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Email (contour jaune)
                    TextFormField(
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _beeOutline(
                        "Email*",
                        errorText: viewModel.emailError,
                        icon: Icons.email,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mot de passe (contour jaune)
                    TextFormField(
                      controller: viewModel.passwordController,
                      obscureText: true,
                      decoration: _beeOutline(
                        "Mot de passe*",
                        errorText: viewModel.passwordError,
                        icon: Icons.lock,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Bouton "CONNEXION" harmonisé
                    if (viewModel.isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: beeYellow,
                            foregroundColor: Colors.black87,
                            elevation: 2,
                            shadowColor: const Color(0x33000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          onPressed: () => viewModel.login(context),
                          child: const Text("CONNEXION"),
                        ),
                      ),

                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
