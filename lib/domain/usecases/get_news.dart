import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsEntity>> call() async {
    return await repository.getNews();
  }
}