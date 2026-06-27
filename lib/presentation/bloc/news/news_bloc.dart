import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/news_entity.dart';
import '../../../domain/usecases/get_news.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;

  NewsBloc(this.getNews) : super(NewsInitial()) {
    on<GetNewsEvent>(_onGetNews);
    on<SearchNewsEvent>(_onSearchNews);
  }

  Future<void> _onGetNews(
    GetNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      // ✅ Pakai getNews() karena usecase pake call()
      final news = await getNews();
      emit(NewsLoaded(news));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      // ✅ Pakai getNews() karena usecase pake call()
      final allNews = await getNews();
      final filtered = allNews
          .where((news) =>
              news.title.toLowerCase().contains(event.query.toLowerCase()) ||
              news.source.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(NewsLoaded(filtered));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}