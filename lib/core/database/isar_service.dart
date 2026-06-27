import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/news_cache.dart';

class IsarService {
  late final Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [NewsCacheSchema],
      directory: dir.path,
    );
  }

  Future<void> saveNews(List<NewsCache> news) async {
    await isar.writeTxn(() async {
      await isar.newsCaches.clear();
      await isar.newsCaches.putAll(news);
    });
  }

  Future<List<NewsCache>> getNews() async {
    return await isar.newsCaches.where().findAll();
  }
}