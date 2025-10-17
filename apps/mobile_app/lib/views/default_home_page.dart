import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '/core/config/app_config.dart';
import '/views/login_page.dart';
import '/views/signup_page.dart';
import '/views/create_incident_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget Login_button(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: const Text("Connect toi !",
          style: TextStyle(
        fontSize: 28,
        color: Colors.green,
      )),
    );
  }

  Widget Signup_button(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupPage()),
        );
      },
      child: const Text("Créer ton compte ! ",
          style: TextStyle(
            fontSize: 28,
            color: Colors.purple,
          )),
    );
  }

  Widget Declare_incident(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateIncidentPage()),
        );
      },
      borderRadius: BorderRadius.circular(16), // effet ripple propre
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFFD4141), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/incident.png",
              width: 32,
              height: 32,
            ),
            SizedBox(width: 12), // espace entre image et texte
            Text(
              "Déclarer un incident",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF0000),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bienvenue sur BEESURE l\'application pour rester en vie sereinement',
              style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
              textAlign: TextAlign.center,),

            const SizedBox(height: 50),
            Login_button(context),

            const SizedBox(height: 50),
            Signup_button(context),

            const SizedBox(height: 50),
            Declare_incident(context),
          ],
        ),
      ),
    );
  }
}