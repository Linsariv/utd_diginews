import '../../domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.title,
    required super.description,
    required super.image,
    required super.source,
    required super.publishedAt,
    required super.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      source: json['source'] != null
          ? json['source']['name'] ?? ''
          : '',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'source': source,
      'publishedAt': publishedAt,
      'url': url,
    };
  }
}