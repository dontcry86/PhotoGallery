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
    } on DioError catch (e) {
      if (e.response == null) {
        emit(BaseErrorState(
            errorCode: networkErrorCode, errorMessage: commonErrorMessage));
      } else {
        emit(BaseErrorState(
            errorCode: systemErrorCode, errorMessage: commonErrorMessage));
      }
    } on Exception catch (_) {
      emit(BaseErrorState(errorMessage: commonErrorMessage));
    }

    /* other way to implement */

    // useCase.getPhotos().then((response) {
    //   if (response != null) {
    //     _mergeBookmarkCacheToPhotos(response);
    //     photos = response;
    //     emit(FetchingPhotoSuccessState(result: photos));
    //   } else {
    //     throw Exception('');
    //   }
    // }).catchError(
    //   (Object obj) {
    //     // non-200 error goes here.
    //     switch (obj.runtimeType) {
    //       case DioError:
    //         // Here's the sample to get the failed response error code and message
    //         final res = (obj as DioError).response;

    //         if (res == null) {
    //           emit(BaseErrorState(
    //               errorCode: networkErrorCode,
    //               errorMessage: commonErrorMessage));
    //         } else {
    //           emit(BaseErrorState(
    //               errorCode: systemErrorCode,
    //               errorMessage: commonErrorMessage));
    //         }

    //         break;
    //       default:
    //         emit(BaseErrorState(
    //             errorCode: systemErrorCode, errorMessage: commonErrorMessage));
    //         break;
    //     }
    //   },
    // );
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

  void switchToBookmarkView() async {
    final data = CacheHandler().markedPhotos;
    emit(FetchingBookmarkSuccessState(result: data));
  }

  void switchBackPhotoGalleryView() async {
    emit(FetchingPhotoSuccessState(result: photos));
  }

  void bookmarkAPhoto(Photo photo) {
    photo.isBookmark = true;
    CacheHandler().bookmarkPhoto(photo);
  }

  void unBookmarkAPhoto(Photo photo, bool isBookmarkMode) {
    photo.isBookmark = false;

    for (final item in (photos ?? [])) {
      if (item.id == photo.id) {
        item.isBookmark = false;
        break;
      }
    }

    CacheHandler().unBookmarkPhoto(photo);
    if (isBookmarkMode) {
      final data = CacheHandler().markedPhotos;
      emit(FetchingBookmarkSuccessState(result: data));
    }
  }
}
