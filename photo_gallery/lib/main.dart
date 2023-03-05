import 'package:flutter/material.dart';
import 'package:photo_gallery/di.dart';
import 'package:photo_gallery/app.dart';
import 'package:photo_gallery/flavor_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(
    flavor: Flavor.prod,
    baseUrl: 'https://jsonplaceholder.typicode.com/',
  );

  configureDependencies();

  runApp(const MyApp());
}
