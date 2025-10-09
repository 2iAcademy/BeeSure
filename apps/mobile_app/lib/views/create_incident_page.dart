import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/declare_incident_view_model.dart';

class CreateIncidentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IncidentViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            // ✅ Carte en fond (placeholder pour l'instant)
            Container(
              color: Colors.grey.shade300, // On mettra ici Google Maps plus tard
              child: Center(
                child: Text(
                  "🗺️ Carte à ajouter ici",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),

            // ✅ Bottom Sheet pour le formulaire
            Align(
              alignment: Alignment.bottomCenter,
              child: Consumer<IncidentViewModel>(
                builder: (context, viewModel, child) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Text(
                            "Déclarer un incident",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),

                          // Champs
                          TextField(
                            controller: viewModel.typeController,
                            decoration: InputDecoration(labelText: "Type (ex: feu, vol)"),
                          ),
                          TextField(
                            controller: viewModel.descriptionController,
                            decoration: InputDecoration(labelText: "Description"),
                          ),
                          TextField(
                            controller: viewModel.latController,
                            decoration: InputDecoration(labelText: "Latitude"),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: viewModel.longController,
                            decoration: InputDecoration(labelText: "Longitude"),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Bouton
                          viewModel.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              viewModel.submitIncident("USER_ID_TEST");
                            },
                            child: Text("Envoyer"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
