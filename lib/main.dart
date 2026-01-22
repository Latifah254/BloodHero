import 'package:bloodhero_app/views/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloodhero_app/controller/themeController.dart';
import 'package:bloodhero_app/views/main_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashView(),
    );
  }
}