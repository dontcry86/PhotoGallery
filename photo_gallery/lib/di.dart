import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_gallery/app/bloc/photo_bloc.dart';
import 'package:photo_gallery/data/networking/networking_service.dart';
import 'package:photo_gallery/data/repositories/photo_repo.dart';
import 'package:photo_gallery/domain/usecases/photo_usecase.dart';
import 'package:photo_gallery/flavor_config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({Interceptor? aliceInterceptor}) async {
  final baseUrl = FlavorConfig.instance?.baseUrl ?? '';
  final headers = {'Authorization': ''};

  final options = BaseOptions(
      connectTimeout: const Duration(seconds: 40), //40s
      receiveTimeout: const Duration(seconds: 10), //10s
      headers: headers,
      contentType: Headers.jsonContentType);

  final dio = Dio(options);
  if (aliceInterceptor != null) {
    dio.interceptors.add(aliceInterceptor);
  }

  await getIt.reset();

  getIt.registerLazySingleton(() => NetworkingService(
        dio,
        baseUrl: baseUrl,
      ));

  getIt.registerFactory<PhotoRepository>(
      () => PhotoRepositoryImpl(networkingService: getIt()));
  getIt.registerFactory<PhotoUseCase>(
      () => PhotoUseCaseImpl(repository: getIt()));
  getIt.registerFactory(
    () => PhotoBloc(
      useCase: getIt(),
    ),
  );

  //getIt.init();
}
