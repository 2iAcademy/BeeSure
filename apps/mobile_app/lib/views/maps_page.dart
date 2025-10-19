// lib/views/maps_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // --- NEW: contrôleur de la GoogleMap + champ recherche
  final Completer<GoogleMapController> _mapCtl =
      Completer<GoogleMapController>();
  final TextEditingController _searchCtl = TextEditingController();

  // Paris par défaut
  CameraPosition _camera = const CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 12,
  );
  bool _myLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    // 1) Permission
    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      setState(() => _myLocationEnabled = false);
      return;
    }

    // 2) Service actif ?
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      setState(() => _myLocationEnabled = false);
      return;
    }

    // 3) Position courante
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final cam = CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 15,
    );

    setState(() {
      _camera = cam; // utile si la map n’est pas encore créée
      _myLocationEnabled = true;
    });

    // 4) Si la map est prête,  déplace la caméra (important)
    if (_mapCtl.isCompleted) {
      final map = await _mapCtl.future;
      await map.animateCamera(CameraUpdate.newCameraPosition(cam));
    }
  }

  // --- NEW: recentrer sur moi (bouton optionnel)
  Future<void> _centerOnMe() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final cam = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15,
      );
      final map = await _mapCtl.future;
      await map.animateCamera(CameraUpdate.newCameraPosition(cam));
    } catch (_) {}
  }

  // --- NEW: recherche d’adresse → recentrage
  Future<void> _searchAndGo(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final results = await geocoding.locationFromAddress(query.trim());
      if (results.isEmpty) return;
      final r = results.first;
      final cam = CameraPosition(
        target: LatLng(r.latitude, r.longitude),
        zoom: 15,
      );
      final map = await _mapCtl.future;
      await map.animateCamera(CameraUpdate.newCameraPosition(cam));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Adresse introuvable')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar supprimée pour placer la barre de recherche dans la carte
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _camera,
            myLocationEnabled: _myLocationEnabled,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            onMapCreated: (c) => _mapCtl.complete(c), // <-- important
          ),

          // --- NEW: barre de recherche en haut
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtl,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _searchAndGo,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher une adresse…',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchAndGo(_searchCtl.text),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- NEW: bouton “me recentrer” (optionnel)
          Positioned(
            right: 12,
            bottom: 88, // au-dessus du bouton natif "ma position"
            child: FloatingActionButton(
              heroTag: 'me',
              onPressed: _centerOnMe,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
