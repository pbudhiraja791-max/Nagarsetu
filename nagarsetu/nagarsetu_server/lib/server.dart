import 'dart:io';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:serverpod/src/web_server/routes/flutter_route.dart';
import 'package:serverpod/src/web_server/routes/static_route.dart';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/web/routes/root.dart';
import 'src/services/data_seeder.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Initialize authentication services for the server.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      ServerpodCloudEmailIdpConfig(
        appDisplayName: 'nagarsetu',
      ),
    ],
  );

// Serve React build if available, otherwise fall back to placeholder
final reactBuildDir = Directory('frontend/dist');
if (reactBuildDir.existsSync()) {
  pod.webServer.addRoute(StaticRoute(reactBuildDir.path), '/');
} else {
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
}

  // Serve all files in the web/static relative directory under /web.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Configure cloud storage.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Start the server.
  await pod.start();

  // Automatically seed initial data if database is fresh
  try {
    final session = await pod.createSession();
    try {
      await DataSeeder.seedIfEmpty(session);
    } finally {
      await session.close();
    }
  } catch (e) {
    // Continue running if seeding was non-fatal
  }
}
