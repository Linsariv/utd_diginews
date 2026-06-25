import 'package:flutter/material.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTD DigiNews',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UTD DigiNews'),
        ),
        body: const Center(
          child: Text('DigiNews Offline First'),
        ),
      ),
    );
  }
}