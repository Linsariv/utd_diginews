import '../../domain/entities/news_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource datasource;

  NewsRepositoryImpl(this.datasource);

  @override
  Future<List<NewsEntity>> getNews() async {
    final news = await datasource.getTopHeadlines();

    // Sorting sesuai aturan dosen
    news.sort(
      (a, b) => a.title.compareTo(b.title),
    );

    return news;
  }
}