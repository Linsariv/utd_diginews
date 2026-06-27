import 'package:get_it/get_it.dart';

import '../../data/datasources/news_remote_datasource.dart';
import '../../data/datasources/news_remote_datasource_impl.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_news.dart';
import '../database/isar_service.dart';
import '../../presentation/bloc/news/news_bloc.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Isar
  final isarService = IsarService();
  await isarService.init();

  sl.registerSingleton<IsarService>(isarService);

  // DataSource
  sl.registerLazySingleton<NewsRemoteDatasource>(
    () => NewsRemoteDatasourceImpl(sl()),
  );

  // Repository
  // ✅ Perbaiki: kirim 2 parameter
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      sl<NewsRemoteDatasource>(), // Parameter 1
      sl<IsarService>(),          // Parameter 2
    ),
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