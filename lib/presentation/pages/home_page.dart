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
            return Center(
              child: Text(
                "Total berita: ${state.news.length}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
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