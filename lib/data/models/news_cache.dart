import 'package:isar/isar.dart';

import 'news_model.dart';
import '../../domain/entities/news_entity.dart'; // ✅ Tambahkan ini

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

  factory NewsCache.fromModel(NewsModel model) {
    return NewsCache.create(
      title: model.title,
      description: model.description,
      image: model.image,
      source: model.source,
      publishedAt: model.publishedAt,
      url: model.url,
    );
  }

  NewsModel toModel() {
    return NewsModel(
      title: title,
      description: description,
      image: image,
      source: source,
      publishedAt: publishedAt,
      url: url,
    );
  }
}

// ✅ Extension dipindahkan ke luar class
extension NewsCacheExtension on NewsCache {
  NewsEntity toEntity() {
    return NewsEntity(
      title: title,
      description: description,
      image: image,
      source: source,
      publishedAt: publishedAt,
      url: url,
    );
  }
}