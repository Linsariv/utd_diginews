import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/news/news_bloc.dart';
import '../widgets/news_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import 'news_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    if (mounted) {
      context.read<NewsBloc>().add(GetNewsEvent());
    }
  }

  void _searchNews(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (mounted) {
      context.read<NewsBloc>().add(SearchNewsEvent(query));
    }
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
    if (mounted) {
      context.read<NewsBloc>().add(GetNewsEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: _searchQuery.isEmpty
            ? const Text(
                "DigiNews",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              )
            : TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari berita...',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),
                ),
                onChanged: _searchNews,
                autofocus: true,
              ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.getThemeIcon()),
            tooltip: _getTooltip(themeProvider.themeMode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
IconButton(
  icon: Icon(
    _searchQuery.isNotEmpty ? Icons.close : Icons.search,
  ),
  onPressed: () {
    if (_searchQuery.isNotEmpty) {
      _clearSearch();
    } else {
      setState(() {
        _searchQuery = ' ';
      });
      // ✅ Pakai WidgetsBinding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).requestFocus();
        }
      });
    }
  },
),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
          ),
        ],
      ),
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: _loadNews,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NewsLoading) {
            return _buildLoadingShimmer();
          }

          if (state is NewsLoaded) {
            final filteredNews = _searchQuery.isNotEmpty
                ? state.news.where((news) =>
                    news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    news.source.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList()
                : state.news;

            if (filteredNews.isEmpty) {
              return _buildEmptySearchState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadNews();
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                key: const PageStorageKey('news_list'),
                itemCount: filteredNews.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final news = filteredNews[index];
                  
                  return NewsCard(
                    news: news,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailPage(news: news),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          if (state is NewsError) {
            return _buildErrorState(state.message);
          }

          return const SizedBox();
        },
      ),
    );
  }

  String _getTooltip(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Switch to Dark Mode';
      case ThemeMode.dark:
        return 'Switch to System Mode';
      default:
        return 'Switch to Light Mode';
    }
  }

  // ✅ Empty Search State
  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Berita tidak ditemukan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba dengan kata kunci lain',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.clear),
            label: const Text('Bersihkan Pencarian'),
          ),
        ],
      ),
    );
  }

  // ✅ Loading Shimmer
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 200,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ Error State
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Oops! Terjadi Kesalahan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadNews,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}