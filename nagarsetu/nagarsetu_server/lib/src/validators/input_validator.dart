class InputValidator {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }

  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone.trim().replaceAll(RegExp(r'[\s-]'), ''));
  }

  static bool isValidCoordinates(double latitude, double longitude) {
    if (latitude < -90.0 || latitude > 90.0) return false;
    if (longitude < -180.0 || longitude > 180.0) return false;
    // Reject dummy (0.0, 0.0) coordinates
    if (latitude == 0.0 && longitude == 0.0) return false;
    return true;
  }

  static bool isValidImageExtension(String filename) {
    final lower = filename.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.heic');
  }

  static bool isValidAudioExtension(String filename) {
    final lower = filename.toLowerCase();
    return lower.endsWith('.mp3') ||
        lower.endsWith('.wav') ||
        lower.endsWith('.m4a') ||
        lower.endsWith('.aac') ||
        lower.endsWith('.ogg');
  }

  static void validateReportInput({
    required String description,
    required String category,
    required double latitude,
    required double longitude,
  }) {
    if (description.trim().length < 3) {
      throw ArgumentError('Problem description must be at least 3 characters long.');
    }
    if (category.trim().isEmpty) {
      throw ArgumentError('Problem category must be selected.');
    }
    if (!isValidCoordinates(latitude, longitude)) {
      throw ArgumentError('Valid GPS coordinates (latitude and longitude) are required.');
    }
  }
}
