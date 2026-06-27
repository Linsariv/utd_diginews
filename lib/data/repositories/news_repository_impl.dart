import '../../domain/entities/news_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';
import '../../core/database/isar_service.dart';
import '../models/news_cache.dart';
import '../../core/utils/logger_service.dart'; // ✅ Tambahkan

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource datasource;
  final IsarService isarService;

  NewsRepositoryImpl(
    this.datasource,
    this.isarService,
  );

  @override
  Future<List<NewsEntity>> getNews() async {
    try {
      // 1. Ambil data dari remote
      final news = await datasource.getTopHeadlines();
      
      if (news.isEmpty) {
        // 2. Kalau kosong, ambil dari cache
        final cachedNews = await isarService.getNews();
        if (cachedNews.isNotEmpty) {
          return cachedNews.map((e) => e.toEntity()).toList();
        }
        return [];
      }

      // 3. Simpan ke cache
      try {
        final cache = news.map((e) => NewsCache.fromModel(e)).toList();
        await isarService.saveNews(cache);
      } catch (cacheError) {
        // ✅ Pakai logger
        LoggerService.error('Failed to save news to cache', cacheError);
      }

      // 4. Sorting
      final sortedNews = List.of(news)
        ..sort((a, b) => a.title.compareTo(b.title));
      
      return sortedNews;
      
    } catch (e) {
      // 5. Error handling - ambil dari cache
      try {
        final cachedNews = await isarService.getNews();
        if (cachedNews.isNotEmpty) {
          LoggerService.info('Returning ${cachedNews.length} news from cache');
          return cachedNews.map((e) => e.toEntity()).toList();
        }
      } catch (cacheError) {
        LoggerService.error('Failed to get news from cache', cacheError);
      }
      
      // 6. Re-throw error kalau ga ada cache
      rethrow;
    }
  }
}