import 'package:code_fit/blocked_and_maintance/data/repo/app_status_repo.dart';
import 'package:code_fit/blocked_and_maintance/logic/app_status_cubit.dart';
import 'package:code_fit/features/login/data/repo/login_repo.dart';
import 'package:code_fit/features/login/logic/login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../api/api_services.dart';
import '../api/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  Dio dio = await DioFactory.initDio();
  getIt.registerLazySingleton<ApiServices>(() => ApiServices(dio));

  // App Status section
  getIt.registerLazySingleton<AppStatusRepo>(() => AppStatusRepo(getIt()));
  getIt.registerFactory<AppStatusCubit>(() => AppStatusCubit(getIt()));

  // login section
  // register section
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
}
