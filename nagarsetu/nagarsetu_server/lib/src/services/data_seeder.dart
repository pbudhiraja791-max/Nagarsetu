import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class DataSeeder {
  static Future<void> seedIfEmpty(Session session) async {
    try {
      final issueCount = await CivicIssue.db.count(session);
      if (issueCount > 0) {
        session.log('Database already populated ($issueCount issues). Skipping seed.');
        return;
      }

      session.log('Seeding initial municipal data and civic issues...');
      final now = DateTime.now();

      // 1. Seed Departments
      final roadDept = await Department.db.insertRow(
        session,
        Department(
          name: 'Road Infrastructure & Potholes',
          description: 'Municipal road repairs, asphalt resurfacing, and pavement maintenance',
          contactEmail: 'roads@nagarsetu.gov',
          contactPhone: '+91 731 2541001',
          isActive: true,
          createdAt: now,
        ),
      );

      final wasteDept = await Department.db.insertRow(
        session,
        Department(
          name: 'Sanitation & Solid Waste',
          description: 'Garbage collection, waste segregation, and community bin management',
          contactEmail: 'sanitation@nagarsetu.gov',
          contactPhone: '+91 731 2541002',
          isActive: true,
          createdAt: now,
        ),
      );

      final drainDept = await Department.db.insertRow(
        session,
        Department(
          name: 'Drainage & Stormwater Management',
          description: 'Underground sewerage, drain desilting, and flood prevention',
          contactEmail: 'drainage@nagarsetu.gov',
          contactPhone: '+91 731 2541003',
          isActive: true,
          createdAt: now,
        ),
      );

      // 2. Seed Default Users
      final citizen = await User.db.insertRow(
        session,
        User(
          name: 'Parth Budhiraja',
          email: 'citizen@nagarsetu.org',
          phone: '+91 9876543210',
          role: 'Citizen',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final roadOfficer = await User.db.insertRow(
        session,
        User(
          name: 'Rajesh Kumar',
          email: 'officer.roads@nagarsetu.gov',
          phone: '+91 9876543211',
          role: 'Officer',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      );

      // 3. Seed Realistic Civic Issues
      final issuesData = [
        {
          'code': 'ISSUE-IN-001',
          'title': 'Pothole near Gandhi Park, Sector 4',
          'category': 'potholes',
          'location': 'Gandhi Park Sector 4',
          'address': 'MG Road, Near Gandhi Park, Indore',
          'lat': 22.7196 + 0.012,
          'lng': 75.8577 - 0.018,
          'status': 'RESOLVED',
          'priority': 7.5,
          'pLevel': 'HIGH',
          'deptId': roadDept.id,
          'resolvedAt': now.subtract(const Duration(hours: 2)),
          'desc': 'Deep crater in asphalt caused traffic congestion and two-wheeler skidding risk.',
        },
        {
          'code': 'ISSUE-IN-002',
          'title': 'Garbage accumulation at Central Market Gate 2',
          'category': 'garbage',
          'location': 'Central Market',
          'address': 'Market Square, Indore',
          'lat': 22.7196 - 0.015,
          'lng': 75.8577 + 0.008,
          'status': 'IN_PROGRESS',
          'priority': 6.2,
          'pLevel': 'MEDIUM',
          'deptId': wasteDept.id,
          'resolvedAt': null,
          'desc': 'Secondary community bin overflowing with commercial vegetable and packaging waste.',
        },
        {
          'code': 'ISSUE-IN-003',
          'title': 'Broken drainage cover on Ring Road Junction 9',
          'category': 'drainage',
          'location': 'Ring Road Junction 9',
          'address': 'Ring Road, Near Service Lane, Indore',
          'lat': 22.7196 + 0.024,
          'lng': 75.8577 + 0.022,
          'status': 'OPEN',
          'priority': 9.1,
          'pLevel': 'CRITICAL',
          'deptId': drainDept.id,
          'resolvedAt': null,
          'desc': 'Missing concrete manhole slab creating acute accident hazard on high-speed corridor.',
        },
        {
          'code': 'ISSUE-IN-004',
          'title': 'Deep road depression near Station Flyover',
          'category': 'potholes',
          'location': 'Station Road Flyover',
          'address': 'Railway Station Flyover Descent, Indore',
          'lat': 22.7196 - 0.022,
          'lng': 75.8577 - 0.025,
          'status': 'OPEN',
          'priority': 8.4,
          'pLevel': 'HIGH',
          'deptId': roadDept.id,
          'resolvedAt': null,
          'desc': 'Sunken trench across both lanes following pipeline repair.',
        },
        {
          'code': 'ISSUE-IN-005',
          'title': 'Blocked storm drain cleared before monsoon',
          'category': 'drainage',
          'location': 'Civil Lines North Avenue',
          'address': 'Civil Lines Ward 12, Indore',
          'lat': 22.7196 - 0.008,
          'lng': 75.8577 - 0.012,
          'status': 'RESOLVED',
          'priority': 5.8,
          'pLevel': 'MEDIUM',
          'deptId': drainDept.id,
          'resolvedAt': now.subtract(const Duration(days: 1)),
          'desc': 'Heavy siltation and plastic bag clogging cleared by municipal jetting machine.',
        },
      ];

      for (final item in issuesData) {
        final issue = await CivicIssue.db.insertRow(
          session,
          CivicIssue(
            issueCode: item['code'] as String,
            title: item['title'] as String,
            category: item['category'] as String,
            descriptionSummary: item['desc'] as String,
            locationName: item['location'] as String,
            address: item['address'] as String,
            latitude: item['lat'] as double,
            longitude: item['lng'] as double,
            status: item['status'] as String,
            priorityScore: item['priority'] as double,
            priorityLevel: item['pLevel'] as String,
            priorityExplanation: 'Evaluated based on hazard category, road type, and citizen volume.',
            totalReports: 1,
            uniqueCitizens: 1,
            assignedDepartmentId: item['deptId'] as int?,
            assignedOfficerId: roadOfficer.id,
            firstReportedAt: now.subtract(const Duration(hours: 6)),
            lastReportedAt: now.subtract(const Duration(hours: 1)),
            resolvedAt: item['resolvedAt'] as DateTime?,
            reopenedCount: 0,
            createdAt: now.subtract(const Duration(hours: 6)),
            updatedAt: now,
          ),
        );

        // Insert matching citizen report
        await CitizenReport.db.insertRow(
          session,
          CitizenReport(
            citizenId: citizen.id ?? 1,
            issueId: issue.id,
            description: item['desc'] as String,
            category: item['category'] as String,
            latitude: item['lat'] as double,
            longitude: item['lng'] as double,
            address: item['address'] as String,
            duplicateDetectionStatus: 'UNIQUE',
            submissionStatus: item['status'] as String,
            counted: true,
            repeatReporter: false,
            createdAt: now.subtract(const Duration(hours: 6)),
          ),
        );
      }

      session.log('Seeded ${issuesData.length} initial civic issues successfully.');
    } catch (e, stack) {
      session.log('Data seeding warning: $e\n$stack', level: LogLevel.warning);
    }
  }
}
