import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

// 🧩 Imports internes
import 'core/config/app_config.dart';
import 'views/default_home_page.dart';
import 'views/create_incident_page.dart';
import 'views/success_page.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';
import 'view_models/declare_incident_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Le ChangeNotifierProvider englobe toute ton app
    return ChangeNotifierProvider(
      create: (_) => IncidentViewModel(),
      child: MaterialApp(
        title: 'BeeSure Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(title: 'BeeSure - Déclaration d\'incident'),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/createIncident': (context) => CreateIncidentPage(),
          '/success': (context) => SuccessPage(),
        },
      ),
    );
  }
}
