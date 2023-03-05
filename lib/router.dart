import 'package:flutter/material.dart';
import 'package:photo_gallery/app/pages/detail_page/detail_page.dart';
import 'package:photo_gallery/app/pages/listing_page/listing_page.dart';
import 'package:photo_gallery/domain/entities/photos_with_selected_index.dart';
import 'app/pages/sample_menu_page/sample_menu_page.dart';
import 'app/widgets/empty_state_wiew.dart';

class RoutePaths {
  static const String prefix = '/photo_gallery';
  static const String listing = '$prefix/listing';
  static const String detail = '$prefix/detail';
  static const String sampleMenu = '$prefix/sample_menu';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case RoutePaths.sampleMenu:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SampleMenuPage(),
        );

      case RoutePaths.listing:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ListingPage(),
        );

      case RoutePaths.detail:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DetailPage(
            data: arguments as PhotosWithSelectedIndex?,
          ),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: EmptyStateView(
              title: 'ROUTE NOT FOUND !',
              message: 'You have unsupported route.',
              showImage: false,
              showButton: false,
              onBtnPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
    }
  }
}

/// PopResult
class PopWithResults<T> {
  /// poped from this page
  final String fromPage;

  /// pop until this page
  final String toPage;

  /// results
  final Map<String, T>? results;

  /// constructor
  PopWithResults({required this.fromPage, required this.toPage, this.results});
}
