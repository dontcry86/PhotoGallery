import 'package:injectable/injectable.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/data/repositories/photo_repo.dart';

abstract class PhotoUseCase {
  Future<List<Photo>?> getPhotos();
}

@Injectable(as: PhotoUseCase)
class PhotoUseCaseImpl extends PhotoUseCase {
  final PhotoRepository repository;
  PhotoUseCaseImpl({required this.repository});
  @override
  Future<List<Photo>?> getPhotos() async {
    return repository.getPhotos();
  }
}
