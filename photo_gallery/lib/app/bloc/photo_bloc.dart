import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_gallery/common/constants.dart';
import 'package:photo_gallery/domain/usecases/photo_usecase.dart';
import 'bloc.dart';

@injectable
class PhotoBloc extends Cubit<BaseState> {
  final PhotoUseCase useCase;

  PhotoBloc({
    required this.useCase,
  }) : super(BaseInitialState());

  void getPhotos() async {
    try {
      final response = await useCase.getPhotos();

      if (response != null) {
        emit(PhotoSuccessState(result: response));
      } else {
        throw Exception('');
      }
    } on DioError catch (_) {
      emit(BaseErrorState(errorMessage: CommonErrorMessage));
    } on Exception catch (_) {
      emit(BaseErrorState(errorMessage: CommonErrorMessage));
    }
  }
}
