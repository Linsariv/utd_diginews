import 'package:get_it/get_it.dart';

import '../../data/datasources/news_remote_datasource.dart';
import '../../data/datasources/news_remote_datasource_impl.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_news.dart';
import '../../presentation/bloc/news/news_bloc.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // DataSource
  sl.registerLazySingleton<NewsRemoteDatasource>(
    () => NewsRemoteDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl()),
  );

  // UseCase
  sl.registerLazySingleton(
    () => GetNews(sl()),
  );

  // Bloc
  sl.registerFactory(
    () => NewsBloc(sl()),
  );
}