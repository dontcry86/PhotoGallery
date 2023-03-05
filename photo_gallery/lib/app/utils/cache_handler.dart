import 'dart:convert';
import 'package:cache_manager/cache_manager.dart';
import 'package:photo_gallery/data/entities/photo.dart';

class CacheHandler {
  static final CacheHandler _singleton = CacheHandler._internal();

  List<Photo> markedPhotos = [];

  final String bookmarkKey = 'bookmark';
  final int invalidIndex = -999;

  factory CacheHandler() {
    return _singleton;
  }

  CacheHandler._internal();

  void bookmarkPhoto(Photo photo) {
    if (checkExistInCaches(photo) == invalidIndex) {
      markedPhotos.add(photo);
      _saveToStorage();
    }
  }

  void unBookmarkPhoto(Photo photo) {
    final index = checkExistInCaches(photo);
    if (index != invalidIndex) {
      markedPhotos.removeAt(index);
      _saveToStorage();
    }
  }

  Future<void> getCaches() async {
    final caches = await ReadCache.getStringList(key: bookmarkKey);

    if (caches is List<String>) {
      final photos = caches.map((item) {
        return Photo.fromJson(jsonDecode(item));
      }).toList();
      markedPhotos.clear();
      markedPhotos.addAll(photos);
    }
  }

  void _saveToStorage() {
    final photosEncoded = markedPhotos.map((item) {
      return jsonEncode(item.toJson());
    }).toList();

    WriteCache.setListString(key: bookmarkKey, value: photosEncoded);
  }

  int checkExistInCaches(Photo photo) {
    for (int index = 0; index < markedPhotos.length; index++) {
      final item = markedPhotos[index];
      if (item.id == photo.id) {
        return index;
      }
    }
    return invalidIndex;
  }
}
