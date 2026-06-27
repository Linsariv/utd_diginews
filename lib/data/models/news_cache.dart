import 'package:isar/isar.dart';

part 'news_cache.g.dart';

@collection
class NewsCache {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late String image;
  late String source;
  late String publishedAt;
  late String url;

  NewsCache();

  NewsCache.create({
    required this.title,
    required this.description,
    required this.image,
    required this.source,
    required this.publishedAt,
    required this.url,
  });
}