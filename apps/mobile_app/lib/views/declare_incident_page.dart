import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../view_models/declare_incident_view_model.dart';

class DeclareIncidentPage extends StatelessWidget {
  const DeclareIncidentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = DeclareIncidentViewModel();

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // 🗺️ Carte
             // ClipRRect(
             //   borderRadius: const BorderRadius.only(
             //     bottomLeft: Radius.circular(40),
             //     bottomRight: Radius.circular(40),
             //   ),
             //   child: GoogleMap(
             //     onMapCreated: (controller) => viewModel.mapController = controller,
             //     initialCameraPosition: CameraPosition(
             //       target: viewModel.currentPosition,
             //       zoom: 14,
              //    ),
             //     myLocationEnabled: true,
              //    zoomControlsEnabled: false,
                //),
              //),

              // 🎯 Indicateur
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: const Icon(Icons.navigation, size: 50, color: Colors.black),
                ),
              ),

              // 📋 Bottom Sheet
              Container(
                padding: const EdgeInsets.all(20),
                height: 360,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Déclarer un incident",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // 🧩 Grille
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        children: viewModel.incidentTypes.map((incident) {
                          final isSelected =
                              viewModel.selectedIncident == incident['label'];
                          return GestureDetector(
                            onTap: () => viewModel.selectIncident(incident['label']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? incident['color'].withOpacity(0.1)
                                    : Colors.grey.shade100,
                                border: Border.all(
                                  color: isSelected
                                      ? incident['color']
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(incident['icon'],
                                      color: incident['color'], size: 35),
                                  const SizedBox(height: 8),
                                  Text(incident['label'],
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🚫 & ✅ Boutons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Annuler"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: viewModel.selectedIncident == null
                                ? null
                                : () async {
                              await viewModel.submitIncident(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                                : const Text("Suivant"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
