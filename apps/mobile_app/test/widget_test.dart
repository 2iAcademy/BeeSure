// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';
import 'package:provider/provider.dart';

import 'package:mobile_app/views/login_page.dart';
import 'package:mobile_app/view_models/login_view_model.dart';


void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  testWidgets('finds a Text widget', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('H'))));

    expect(find.text('H'), findsOneWidget);
  });

  testWidgets('Title of login_page', (WidgetTester  tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Connexion'), findsOneWidget);


  expect(find.text("Bienvenue sur BeeSure !"), findsOneWidget);

  // Vérifie les labels des champs
  expect(find.text("Email*"), findsOneWidget);
  expect(find.text("Mot de passe*"), findsOneWidget);

  // Vérifie les icônes des champs
  expect(find.byIcon(Icons.email), findsOneWidget);
  expect(find.byIcon(Icons.lock), findsOneWidget);

  // Vérifie la présence du bouton de connexion
  expect(find.byType(ElevatedButton), findsOneWidget);
  expect(find.text("Se connecter"), findsOneWidget);

  });

  testWidgets('LoginPage - check fields well here (emails and password)', (WidgetTester tester) async {
    // Construit le widget LoginPage
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Vérifie la présence des champs TextFormField
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Trouve les champs par leur label
    final emailLabelFinder = find.text("Email*");
    final passwordLabelFinder = find.text("Mot de passe*");

    expect(emailLabelFinder, findsOneWidget);
    expect(passwordLabelFinder, findsOneWidget);

  });
}