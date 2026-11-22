import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../utils/hash_utils.dart';
import '../validators/input_validator.dart';

class StorageService {
  static const String _baseUploadDir = 'storage/uploads';

  /// Saves binary file (image or audio) to disk and returns unique public reference URL
  static Future<String> saveFile({
    required Uint8List bytes,
    required String originalFilename,
    required String fileType, // 'image' or 'audio'
  }) async {
    if (fileType == 'image') {
      if (!InputValidator.isValidImageExtension(originalFilename)) {
        throw ArgumentError('Unsupported image extension for $originalFilename. Permitted: jpg, jpeg, png, webp, heic.');
      }
    } else if (fileType == 'audio') {
      if (!InputValidator.isValidAudioExtension(originalFilename)) {
        throw ArgumentError('Unsupported audio extension for $originalFilename. Permitted: mp3, wav, m4a, aac, ogg.');
      }
    }

    final ext = originalFilename.contains('.') ? originalFilename.split('.').last : (fileType == 'image' ? 'jpg' : 'm4a');
    final uniqueId = const Uuid().v4();
    final fileName = '$uniqueId.$ext';
    
    final targetDir = Directory('$_baseUploadDir/$fileType');
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final filePath = '${targetDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return '/uploads/$fileType/$fileName';
  }

  /// Calculates SHA-256 hash for deduplication check
  static String calculateHash(Uint8List bytes) {
    return HashUtils.bytesToSha256(bytes);
  }
}
