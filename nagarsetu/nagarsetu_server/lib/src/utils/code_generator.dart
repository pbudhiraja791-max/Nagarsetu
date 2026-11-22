import 'dart:math';

class CodeGenerator {
  static final _random = Random();

  /// Generates an issue code like NG-1001 or NG-5829
  static String generateIssueCode(int sequenceId) {
    if (sequenceId > 0) {
      return 'NG-${1000 + sequenceId}';
    }
    final rand = 1000 + _random.nextInt(9000);
    return 'NG-$rand';
  }

  /// Generates a tracking ID like REP-20261122-4821
  static String generateTrackingId(int? reportId) {
    final now = DateTime.now().toUtc();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final suffix = reportId ?? (1000 + _random.nextInt(9000));
    return 'REP-$dateStr-$suffix';
  }
}
