import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/declare_incident_view_model.dart';
import '../features/enum/incident_type_enum.dart';

class CreateIncidentPage extends StatelessWidget {
  static const Map<IncidentTypeEnum, String> _assetForType = {
    IncidentTypeEnum.INCENDIE: 'incendie.png',
    IncidentTypeEnum.AGRESSION: "/fight.png",
    IncidentTypeEnum.NATUREL: "/catastrophe.png",
    IncidentTypeEnum.VOL: "vol.png",
    IncidentTypeEnum.ARME: "/armes.png",
    IncidentTypeEnum.AUTRE: "/autres.png",
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IncidentViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            // ✅ Carte en fond
            Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Text(
                  "🗺️ Carte à ajouter ici",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),

            // ✅ Bouton pour ouvrir le bottom sheet
            Positioned(
              bottom: 40,
              right: 20,
              child: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text("Déclarer"),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // permet un grand contenu
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (BuildContext context) {
                      return ChangeNotifierProvider.value(
                        value: Provider.of<IncidentViewModel>(context),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 16,
                            right: 16,
                            top: 10,
                          ),
                          child: Consumer<IncidentViewModel>(
                            builder: (context, viewModel, child) {
                              return SingleChildScrollView(
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
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: IncidentTypeEnum.values.map((type) {
                                              return GestureDetector(
                                                onTap: () => viewModel.selectIncidentType(type),
                                                child: Container(
                                                  width: 100,
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: viewModel.selectedType == type
                                                        ? Colors.blue.shade100
                                                        : Colors.grey.shade200,
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: viewModel.selectedType == type
                                                          ? Colors.blue
                                                          : Colors.grey.shade400,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(_assetForType[type]!, fit: BoxFit.contain),
                                                      SizedBox(height: 8),
                                                      Text(type.label, textAlign: TextAlign.center),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: viewModel.selectedType == null
                                                ? null
                                                : () => viewModel.nextStep(),
                                            child: Text("Suivant"),
                                          ),
                                        ],
                                      ),

                                    // ✅ Étape 2 : Description + Envoi
                                    if (viewModel.currentStep == 2)
                                      Column(
                                        children: [
                                          TextField(
                                            controller: viewModel.descriptionController,
                                            decoration: InputDecoration(labelText: "Description (optionnel)"),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await viewModel.submitIncident(context, "1");

                                              // ✅ Pop-up de confirmation
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext dialogContext) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.check_circle_outline,
                                                            color: Colors.green, size: 60),
                                                        SizedBox(height: 16),
                                                        Text(
                                                          "Opération réussie !",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ).then((_) {
                                                viewModel.clearForm();
                                                // ✅ Quand la pop-up se ferme, on ferme le bottom sheet
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text("Envoyer"),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
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
