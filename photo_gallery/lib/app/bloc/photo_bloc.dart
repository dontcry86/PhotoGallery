import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_gallery/app/utils/cache_handler.dart';
import 'package:photo_gallery/common/constants.dart';
import 'package:photo_gallery/data/entities/photo.dart';
import 'package:photo_gallery/domain/usecases/photo_usecase.dart';
import 'bloc.dart';

@injectable
class PhotoBloc extends Cubit<BaseState> {
  final PhotoUseCase useCase;
  List<Photo>? photos;

  PhotoBloc({
    required this.useCase,
  }) : super(BaseInitialState());

  void getPhotosFromAPI() async {
    try {
      final response = await useCase.getPhotos();
      if (response != null) {
        _mergeBookmarkCacheToPhotos(response);
        photos = response;
        emit(FetchingPhotoSuccessState(result: photos));
      } else {
        throw Exception('');
      }
    } on DioError catch (_) {
      emit(BaseErrorState(errorMessage: CommonErrorMessage));
    } on Exception catch (_) {
      emit(BaseErrorState(errorMessage: CommonErrorMessage));
    }
  }

  void _mergeBookmarkCacheToPhotos(List<Photo> photos) {
    final markedPhotos = CacheHandler().markedPhotos;
    for (final markedItem in markedPhotos) {
      for (var photo in photos) {
        if (markedItem.id == photo.id) {
          photo.isBookmark = true;
          break;
        }
      }
    }
  }

  void switchToBookmark() async {
    final data = CacheHandler().markedPhotos;
    emit(FetchingBookmarkSuccessState(result: data));
  }

  void switchBackPhotoGallery() async {
    emit(FetchingPhotoSuccessState(result: photos));
  }
}
