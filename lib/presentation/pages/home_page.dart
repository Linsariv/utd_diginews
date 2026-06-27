import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/news/news_bloc.dart';
import '../bloc/news/news_event.dart';
import '../bloc/news/news_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    context.read<NewsBloc>().add(
      GetNewsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DigiNews"),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {

          if (state is NewsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

if (state is NewsLoaded) {
  return ListView.builder(
    itemCount: state.news.length,
    itemBuilder: (context, index) {
      final news = state.news[index];

      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: ListTile(
          leading: news.image.isNotEmpty
              ? ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Image.network(
    news.image,
    width: 80,
    height: 80,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image),
      );
    },
  ),
)
              : const Icon(Icons.image),

          title: Text(
            news.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(news.source),
              const SizedBox(height: 4),
              Text(
                news.publishedAt,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    },
  );
}

          if (state is NewsError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}