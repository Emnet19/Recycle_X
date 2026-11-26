import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Handles device location permissions and retrieves the current position.
/// Also provides human-readable place name / address resolution (Requirement 5).
class LocationService {
  LocationService._();

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Resolves coordinates to a human-readable place name or address (Requirement 5).
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'RecycleX-App/1.0 (waste-management)'},
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>?;
        if (address != null) {
          final road = address['road'] ?? address['pedestrian'] ?? address['suburb'];
          final subcity = address['city_district'] ?? address['suburb'] ?? address['neighbourhood'];
          final city = address['city'] ?? address['town'] ?? 'Addis Ababa';

          if (road != null && subcity != null) {
            return '$road, $subcity, $city';
          } else if (subcity != null) {
            return '$subcity, $city';
          } else if (data['display_name'] != null) {
            final parts = (data['display_name'] as String).split(',');
            if (parts.length >= 2) {
              return '${parts[0].trim()}, ${parts[1].trim()}';
            }
            return parts[0].trim();
          }
        }
      }
    } catch (_) {
      // Offline, network timeout, or platform limitation fallback
    }

    // Proximity fallback to known readable neighborhoods in Addis Ababa
    return _getFallbackReadableNeighborhood(latitude, longitude);
  }

  static String _getFallbackReadableNeighborhood(double lat, double lng) {
    // Distance approximation to prominent Addis Ababa hubs
    final places = [
      (9.0054, 38.7636, 'Bole Medhanialem, Bole Sub-City, Addis Ababa'),
      (9.0150, 38.7550, 'Kazanchis, Kirkos Sub-City, Addis Ababa'),
      (9.0350, 38.7520, 'Piazza, Arada Sub-City, Addis Ababa'),
      (9.0100, 38.7700, 'Megenagna Hub, Yeka Sub-City, Addis Ababa'),
      (9.0200, 38.7800, 'CMC Michael, Yeka Sub-City, Addis Ababa'),
      (9.0220, 38.7420, 'Mexico Square, Kirkos, Addis Ababa'),
      (8.9950, 38.7500, 'Sarbet, Nifas Silk-Lafto, Addis Ababa'),
      (9.0400, 38.7600, '4 Kilo Palace Area, Arada, Addis Ababa'),
      (9.0600, 38.8600, 'Ayat Zone 3, Bole Sub-City, Addis Ababa'),
    ];

    double closestDist = double.infinity;
    String closestName = 'Bole Sub-City, Addis Ababa';

    for (final p in places) {
      final dLat = lat - p.$1;
      final dLng = lng - p.$2;
      final distSq = (dLat * dLat) + (dLng * dLng);
      if (distSq < closestDist) {
        closestDist = distSq;
        closestName = p.$3;
      }
    }

    return closestName;
  }
}
