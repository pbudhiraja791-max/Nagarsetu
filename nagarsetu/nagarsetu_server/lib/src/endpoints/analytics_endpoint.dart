import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/analytics_service.dart';

class AnalyticsEndpoint extends Endpoint {
  /// Fetches system-wide civic performance indicators, category distribution, and resolution metrics
  Future<DashboardAnalytics> getDashboardAnalytics(Session session) async {
    return await AnalyticsService.getDashboardAnalytics(session);
  }
}
