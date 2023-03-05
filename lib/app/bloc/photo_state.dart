import 'package:photo_gallery/app/bloc/base/base_state.dart';
import 'package:photo_gallery/data/entities/photo.dart';

class FetchingPhotoSuccessState extends BaseSuccessState<List<Photo>?> {
  FetchingPhotoSuccessState({List<Photo>? result}) : super(result: result);
}

class FetchingBookmarkSuccessState extends BaseSuccessState<List<Photo>?> {
  FetchingBookmarkSuccessState({List<Photo>? result}) : super(result: result);
}
