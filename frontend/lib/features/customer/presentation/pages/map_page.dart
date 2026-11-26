import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';

/// Map page — migrated from lib/pages/map.dart.
/// Shows user location and nearest collector marker.
class MapPage extends StatelessWidget {
  final LatLng userLocation;

  const MapPage({super.key, required this.userLocation});

  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: userLocation,
        infoWindow: const InfoWindow(title: 'You'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen),
      ),
      const Marker(
        markerId: MarkerId('collector1'),
        position: LatLng(9.03, 38.74),
        infoWindow: InfoWindow(title: 'Nearest Collector'),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Collectors'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 14,
        ),
        markers: markers,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
