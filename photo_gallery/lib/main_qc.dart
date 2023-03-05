import 'package:flutter/material.dart';
import 'package:photo_gallery/di.dart';
import 'package:photo_gallery/app.dart';
import 'package:photo_gallery/flavor_config.dart';
import 'package:alice/alice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(
    flavor: Flavor.qc,
    baseUrl: 'https://jsonplaceholder.typicode.com/',
  );

  Alice alice = Alice();

  configureDependencies(aliceInterceptor: alice.getDioInterceptor());

  runApp(MyApp(
    navigatorKey: alice.getNavigatorKey(),
  ));
}
