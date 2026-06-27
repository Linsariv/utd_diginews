import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';  // ✅ Tambahkan ini

import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';        // ✅ Import theme
import 'core/theme/theme_provider.dart';   // ✅ Import theme provider
import 'presentation/bloc/news/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),  // ✅ Registrasi ThemeProvider
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocProvider(
      create: (_) => sl<NewsBloc>(),
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        title: 'DigiNews',
        theme: AppTheme.lightTheme,        // ✅ Pakai AppTheme
        darkTheme: AppTheme.darkTheme,     // ✅ Pakai AppTheme
        themeMode: themeProvider.themeMode, // ✅ Ikuti theme provider
      ),
    );
  }
}