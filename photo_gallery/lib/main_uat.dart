import 'package:flutter/material.dart';
import 'package:photo_gallery/di.dart';
import 'package:photo_gallery/app.dart';
import 'package:photo_gallery/flavor_config.dart';
import 'package:alice/alice.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(
    flavor: Flavor.uat,
    baseUrl: 'https://jsonplaceholder.typicode.com/',
  );

  Alice? alice;

  final aliceGranted = kDebugMode && GetPlatform.isMobile;

  if (aliceGranted) {
    alice = Alice();
  }

  configureDependencies(
      aliceInterceptor: (aliceGranted ? alice?.getDioInterceptor() : null));

  runApp(MyApp(
    navigatorKey: (aliceGranted ? alice?.getNavigatorKey() : null),
  ));
}
