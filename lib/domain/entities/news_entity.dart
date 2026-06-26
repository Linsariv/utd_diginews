class NewsEntity {
  final String title;
  final String description;
  final String image;
  final String source;
  final String publishedAt;
  final String url;

  const NewsEntity({
    required this.title,
    required this.description,
    required this.image,
    required this.source,
    required this.publishedAt,
    required this.url,
  });
}