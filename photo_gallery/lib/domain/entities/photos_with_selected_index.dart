import 'package:photo_gallery/data/entities/photo.dart';

class PhotosWithSelectedIndex {
  final int? selectedIndex;
  final List<Photo> photos;
  const PhotosWithSelectedIndex({this.selectedIndex, required this.photos});
}
