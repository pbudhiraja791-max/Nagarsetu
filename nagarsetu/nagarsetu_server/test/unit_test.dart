import 'package:test/test.dart';
import 'package:nagarsetu_server/src/utils/geo_utils.dart';
import 'package:nagarsetu_server/src/utils/code_generator.dart';
import 'package:nagarsetu_server/src/utils/hash_utils.dart';
import 'package:nagarsetu_server/src/validators/input_validator.dart';
import 'package:nagarsetu_server/src/services/priority_calculation_service.dart';

void main() {
  group('GeoUtils Tests', () {
    test('Calculates accurate Haversine distance between two coordinates', () {
      // Coordinates in Patiala/Rajpura: ~111m per 0.001 deg lat
      final lat1 = 30.4842;
      final lon1 = 76.5938;
      final lat2 = 30.4842;
      final lon2 = 76.5938;
      expect(GeoUtils.haversineDistance(lat1, lon1, lat2, lon2), closeTo(0.0, 0.01));

      // Slightly separated coordinates
      final lat3 = 30.4845;
      final lon3 = 76.5938;
      final distance = GeoUtils.haversineDistance(lat1, lon1, lat3, lon3);
      expect(distance, greaterThan(30.0));
      expect(distance, lessThan(40.0));
    });

    test('Returns appropriate category radii', () {
      expect(GeoUtils.getRadiusForCategory('Pothole'), equals(30.0));
      expect(GeoUtils.getRadiusForCategory('Garbage'), equals(75.0));
      expect(GeoUtils.getRadiusForCategory('Drainage'), equals(50.0));
      expect(GeoUtils.getRadiusForCategory('Streetlight'), equals(20.0));
      expect(GeoUtils.getRadiusForCategory('Unknown'), equals(40.0)); // fallback
    });

    test('Proximity similarity decays smoothly from 1.0 to 0.0', () {
      expect(GeoUtils.proximitySimilarity(0.0, 30.0), equals(1.0));
      expect(GeoUtils.proximitySimilarity(30.0, 30.0), equals(0.0));
      expect(GeoUtils.proximitySimilarity(60.0, 30.0), equals(0.0));
      final midSim = GeoUtils.proximitySimilarity(15.0, 30.0);
      expect(midSim, greaterThan(0.4));
      expect(midSim, lessThan(0.6));
    });
  });

  group('InputValidator Tests', () {
    test('Validates correct emails and rejects invalid ones', () {
      expect(InputValidator.isValidEmail('citizen@nagarsetu.gov.in'), isTrue);
      expect(InputValidator.isValidEmail('test.user@gmail.com'), isTrue);
      expect(InputValidator.isValidEmail('invalid-email'), isFalse);
      expect(InputValidator.isValidEmail('@nodomain.com'), isFalse);
    });

    test('Validates GPS coordinates and rejects (0,0) dummy values', () {
      expect(InputValidator.isValidCoordinates(30.4842, 76.5938), isTrue);
      expect(InputValidator.isValidCoordinates(0.0, 0.0), isFalse);
      expect(InputValidator.isValidCoordinates(95.0, 50.0), isFalse);
      expect(InputValidator.isValidCoordinates(30.0, 195.0), isFalse);
    });

    test('Validates image and audio file extensions', () {
      expect(InputValidator.isValidImageExtension('evidence.jpg'), isTrue);
      expect(InputValidator.isValidImageExtension('photo.PNG'), isTrue);
      expect(InputValidator.isValidImageExtension('document.pdf'), isFalse);

      expect(InputValidator.isValidAudioExtension('voice_note.m4a'), isTrue);
      expect(InputValidator.isValidAudioExtension('recording.mp3'), isTrue);
      expect(InputValidator.isValidAudioExtension('song.exe'), isFalse);
    });
  });

  group('PriorityCalculationService Tests', () {
    test('Calculates dynamic priority score between 0 and 100', () {
      final now = DateTime.now().toUtc();
      final resLow = PriorityCalculationService.calculatePriority(
        totalReports: 1,
        uniqueCitizens: 1,
        severityScore: 30.0,
        category: 'Streetlight',
        firstReportedAt: now,
        reopenedCount: 0,
      );
      expect(resLow.score, greaterThan(0.0));
      expect(resLow.score, lessThan(60.0));

      final resEscalated = PriorityCalculationService.calculatePriority(
        totalReports: 15,
        uniqueCitizens: 12,
        severityScore: 85.0,
        category: 'Open Manhole',
        firstReportedAt: now.subtract(const Duration(days: 7)),
        reopenedCount: 2,
      );
      expect(resEscalated.score, greaterThan(75.0));
      expect(resEscalated.level, anyOf(equals('High'), equals('Critical')));
      expect(resEscalated.explanation, contains('Freq 30%'));
    });
  });

  group('CodeGenerator & HashUtils Tests', () {
    test('Generates sequential formatted issue codes', () {
      expect(CodeGenerator.generateIssueCode(1), equals('NG-1001'));
      expect(CodeGenerator.generateTrackingId(1), startsWith('REP-'));
    });

    test('Computes deterministic SHA-256 hashes', () {
      final hash1 = HashUtils.sha256String('NagarSetu Civic Intelligence');
      final hash2 = HashUtils.sha256String('NagarSetu Civic Intelligence');
      expect(hash1, equals(hash2));
      expect(hash1.length, equals(64));
    });
  });
}
