import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/declare_incident_view_model.dart';

class CreateIncidentPage extends StatelessWidget {

  Widget incidentTypeButton(IncidentViewModel viewModel, String label, String assetPath) {
    bool isSelected = viewModel.selectedType == label;
    return GestureDetector(
      onTap: () => viewModel.selectIncidentType(label),
      child: Container(
        width: 90,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
            SizedBox(height: 5),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

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
                          Text("Déclarer un incident",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),

                          // ✅ Étape 1 : Sélection du type
                          if (viewModel.currentStep == 1)
                            Column(
                              children: [
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: [
                                    incidentTypeButton(viewModel, "Incendie", "incendie.png"),
                                    incidentTypeButton(viewModel, "Vol", "vol.png"),
                                    incidentTypeButton(viewModel, "Agression", "/fight.png"),
                                    incidentTypeButton(viewModel, "Catastrophe", "/catastrophe.png"),
                                    incidentTypeButton(viewModel, "Animal", "/animal.png"),
                                    incidentTypeButton(viewModel, "Armes", "/armes.png"),
                                    incidentTypeButton(viewModel, "Autres", "/autres.png"),
                                  ],
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: viewModel.selectedType == null
                                      ? null
                                      : () => viewModel.nextStep(),
                                  child: Text("Suivant"),
                                )
                              ],
                            ),
                          // ✅ Étape 2 : Description
                          if (viewModel.currentStep == 2)
                            Column(
                              children: [
                                TextField(
                                  controller: viewModel.descriptionController,
                                  decoration: InputDecoration(labelText: "Description (optionnel)"),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    //pensez à récupérer l'id du user !!!!!!!!
                                    viewModel.submitIncident("1");
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("✅ Succès"),
                                        content: Text("Incident créé avec succès"),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () => Navigator.pop(context),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text("Envoyer"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // ✅ Bottom Sheet pour le formulaire
            /*Align(
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
            ),*/
          ],
        ),
      ),
    );
  }
}
