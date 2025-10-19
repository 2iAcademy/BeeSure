import 'package:flutter/material.dart';
import '/views/login_page.dart';
import '/views/signup_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const beeYellow = Color(0xFFFFB624);
    const beeDark = Color(0xFF1F1F1F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final isTall = c.maxHeight > 700;

            return Column(
              children: [
                const SizedBox(height: 24),

                // --- Logo + accroche (centrés)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pastille ronde + logo PNG
                      Container(
                        width: 140,
                        height: 140,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            'assets/logo_beesure-transparent.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      Text(
                        "Bienvenue sur BeeSure!",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: beeDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Be safe, BeeSure",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Boutons (ancrés en bas)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PrimaryButton(
                        label: "CONNEXION",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _PrimaryButton(
                        label: "REJOIGNEZ-NOUS",
                        filled: false, // variante outline
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: isTall ? 8 : 0),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    const beeYellow = Color(0xFFFFB624);
    final baseStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: filled ? 2 : 0,
      textStyle: const TextStyle(
        letterSpacing: 1.1,
        fontWeight: FontWeight.w700,
      ),
    );

    return filled
        ? ElevatedButton(
            style: baseStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(beeYellow),
              foregroundColor: WidgetStateProperty.all(Colors.black87),
              shadowColor: WidgetStateProperty.all(const Color(0x33000000)),
            ),
            onPressed: onPressed,
            child: Text(label),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: const BorderSide(color: beeYellow, width: 2),
              textStyle: const TextStyle(
                letterSpacing: 1.1,
                fontWeight: FontWeight.w700,
              ),
              foregroundColor: Colors.black87,
            ),
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
