import 'package:injectable/injectable.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/data/networking/networking_service.dart';

abstract class PhotoRepository {
  Future<List<Photo>?> getPhotos();
}

@Injectable(as: PhotoRepository)
class PhotoRepositoryImpl extends PhotoRepository {
  final NetworkingService networkingService;
  PhotoRepositoryImpl({required this.networkingService});

  @override
  Future<List<Photo>?> getPhotos() async {
    return networkingService.getPhotos();
  }
}
