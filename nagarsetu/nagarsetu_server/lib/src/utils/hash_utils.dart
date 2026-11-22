import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashUtils {
  /// Computes a standard SHA-256 hash of a string
  static String sha256String(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Computes a SHA-256 hash of byte data
  static String sha256Bytes(List<int> bytes) {
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Alias for sha256Bytes
  static String bytesToSha256(List<int> bytes) => sha256Bytes(bytes);
}
