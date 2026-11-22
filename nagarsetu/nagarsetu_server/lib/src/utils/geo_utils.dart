import 'dart:math';

class GeoUtils {
  static const double earthRadiusMeters = 6371000.0;

  /// Default geographical proximity radii per category
  static const Map<String, double> categoryRadiiMeters = {
    'Pothole': 30.0,
    'Damaged Road': 35.0,
    'Garbage': 75.0,
    'Garbage Accumulation': 75.0,
    'Overflowing Dustbin': 60.0,
    'Drainage': 50.0,
    'Drainage / Sewage': 50.0,
    'Drainage Blockage': 50.0,
    'Water Leakage': 40.0,
    'Waterlogging': 60.0,
    'Streetlight': 20.0,
    'Damaged Streetlight': 20.0,
    'Open Manhole': 25.0,
    'Exposed Electrical Wire': 25.0,
    'Broken Public Infrastructure': 40.0,
    'Other': 40.0,
  };

  static double getRadiusForCategory(String category) {
    return categoryRadiiMeters[category] ?? 40.0;
  }

  /// Calculates the Haversine distance in meters between two points
  static double haversineDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  /// Alias for haversineDistanceMeters
  static double haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) => haversineDistanceMeters(lat1, lon1, lat2, lon2);

  /// Normalizes proximity into a similarity score between 0.0 and 1.0
  static double proximitySimilarity(double distanceMeters, double maxRadiusMeters) {
    if (distanceMeters <= 0) return 1.0;
    if (distanceMeters >= maxRadiusMeters) return 0.0;
    // Exponential decay curve
    return max(0.0, 1.0 - (distanceMeters / maxRadiusMeters));
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}
