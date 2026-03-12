import 'dart:math';

class MapHelper {
  MapHelper._();

  static const double _earthRadiusKm = 6371.0;

  /// Calculate distance between two coordinates in kilometers
  static double distanceKm({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  /// Distance in meters
  static double distanceMeters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) =>
      distanceKm(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2) * 1000;

  /// Human-readable distance
  static String distanceDisplay({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    final km = distanceKm(
      lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2,
    );
    if (km < 1) return '${(km * 1000).toStringAsFixed(0)} m';
    return '${km.toStringAsFixed(1)} km';
  }

  /// Rough bounding box for a given center and radius in km
  static Map<String, double> boundingBox({
    required double lat,
    required double lon,
    required double radiusKm,
  }) {
    final latDelta = radiusKm / _earthRadiusKm * (180 / pi);
    final lonDelta = radiusKm /
        (_earthRadiusKm * cos(_toRadians(lat))) *
        (180 / pi);

    return {
      'minLat': lat - latDelta,
      'maxLat': lat + latDelta,
      'minLon': lon - lonDelta,
      'maxLon': lon + lonDelta,
    };
  }

  /// Validate lat/lon coordinates
  static bool isValidCoordinate(double lat, double lon) {
    return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
  }

  /// Midpoint between two coordinates
  static Map<String, double> midpoint({
    required double lat1, required double lon1,
    required double lat2, required double lon2,
  }) {
    final lat = (lat1 + lat2) / 2;
    final lon = (lon1 + lon2) / 2;
    return {'lat': lat, 'lon': lon};
  }

  static double _toRadians(double degrees) => degrees * (pi / 180);
}
