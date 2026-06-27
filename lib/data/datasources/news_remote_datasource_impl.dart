import '../../../core/network/api_client.dart';
import '../models/news_model.dart';
import 'news_remote_datasource.dart';
import '../../../core/config/api_config.dart';

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final ApiClient apiClient;

  NewsRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<NewsModel>> getTopHeadlines() async {
    final response = await apiClient.dio.get(
      ApiConfig.topHeadlines,
      queryParameters: {
        'country': 'id',
        'lang': 'id',
        'max': 10,
        'apikey': ApiConfig.apiKey,
      },
    );

final List<dynamic> articles = response.data['articles'];

return articles
    .map((e) => NewsModel.fromJson(e))
    .toList();
  }
}