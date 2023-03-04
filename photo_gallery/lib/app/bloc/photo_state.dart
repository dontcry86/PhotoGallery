import 'package:photo_gallery/app/bloc/base/base_state.dart';
import 'package:photo_gallery/data/entities/photo.dart';

class PhotoSuccessState extends BaseSuccessState<List<Photo>?> {
  PhotoSuccessState({List<Photo>? result}) : super(result: result);
}
