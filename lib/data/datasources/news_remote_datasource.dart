import '../models/news_model.dart';

abstract class NewsRemoteDatasource {
  Future<List<NewsModel>> getTopHeadlines();
}