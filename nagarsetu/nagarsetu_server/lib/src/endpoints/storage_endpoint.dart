import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../services/storage_service.dart';

class StorageEndpoint extends Endpoint {
  /// Uploads an image encoded in Base64 and returns the stored resource reference URL
  Future<String> uploadImageBase64(
    Session session, {
    required String base64Data,
    required String fileName,
  }) async {
    // Strip data URI prefix if present (e.g. data:image/jpeg;base64,...)
    final cleanBase64 = base64Data.contains(',') ? base64Data.split(',').last : base64Data;
    final bytes = base64Decode(cleanBase64.trim());
    return await StorageService.saveFile(
      bytes: bytes,
      originalFilename: fileName,
      fileType: 'image',
    );
  }

  /// Uploads an audio clip encoded in Base64 and returns the stored resource reference URL
  Future<String> uploadAudioBase64(
    Session session, {
    required String base64Data,
    required String fileName,
  }) async {
    final cleanBase64 = base64Data.contains(',') ? base64Data.split(',').last : base64Data;
    final bytes = base64Decode(cleanBase64.trim());
    return await StorageService.saveFile(
      bytes: bytes,
      originalFilename: fileName,
      fileType: 'audio',
    );
  }
}
