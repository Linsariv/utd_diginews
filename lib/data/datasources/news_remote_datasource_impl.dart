import '../../../core/network/api_client.dart';
import '../models/news_model.dart';
import 'news_remote_datasource.dart';

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final ApiClient apiClient;

  NewsRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<NewsModel>> getTopHeadlines() async {
    final response = await apiClient.dio.get(
      'top-headlines',
      queryParameters: {
        'country': 'id',
        'apikey': 'API_KEY_KAMU',
      },
    );

    final List articles = response.data['articles'];

    return articles
        .map((e) => NewsModel.fromJson(e))
        .toList();
  }
}