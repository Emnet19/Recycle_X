import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final LatLng userLocation;

  const MapPage({super.key, required this.userLocation});

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: userLocation,
        infoWindow: const InfoWindow(title: 'You'),
      ),
      Marker(
        markerId: const MarkerId('collector1'),
        position: const LatLng(9.03, 38.74),
        infoWindow: const InfoWindow(title: 'Nearest Collector'),
      ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Collector')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 14,
        ),
        markers: markers,
      ),
    );
  }
}
