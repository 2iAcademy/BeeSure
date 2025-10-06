import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  CameraPosition _camera = const CameraPosition(
    target: LatLng(48.8566, 2.3522), // Paris par défaut
    zoom: 12,
  );
  bool _myLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    // 1) demander la permission "quand l'app est utilisée"
    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      setState(() => _myLocationEnabled = false);
      return;
    }

    // 2) vérifier que la localisation est activée côté device
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      setState(() => _myLocationEnabled = false);
      return;
    }

    // 3) récupérer la position et centrer la caméra dessus
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _camera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15,
      );
      _myLocationEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BeeSure — Carte')),
      body: GoogleMap(
        initialCameraPosition: _camera,
        myLocationEnabled: _myLocationEnabled,
        myLocationButtonEnabled: true,
        compassEnabled: true,
      ),
    );
  }
}
