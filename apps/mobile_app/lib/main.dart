import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'views/default_home_page.dart';
import 'views/create_incident_page.dart';
import 'views/success_page.dart';
import 'views/login_page.dart';
import 'views/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'BeeSure Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'BeeSure - Déclaration d\'incident'),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
      },
      //home: const MyHomePage(title: 'BeeSure - Déclaration d\'incident'),
    );
  }
}




