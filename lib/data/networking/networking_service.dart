import 'package:dio/dio.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:retrofit/retrofit.dart';
part 'networking_service.g.dart';

@RestApi(baseUrl: "this url will be ignored if baseUrl is passed")
abstract class NetworkingService {
  factory NetworkingService(Dio dio, {String baseUrl}) = _NetworkingService;

  @GET('/photos')
  @NoBody()
  Future<List<Photo>?> getPhotos();
}
