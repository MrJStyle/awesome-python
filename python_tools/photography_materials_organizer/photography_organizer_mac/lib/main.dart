import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhotographyOrganizerApp());
}

class PhotographyOrganizerApp extends StatelessWidget {
  const PhotographyOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '摄影素材整理',
      debugShowCheckedModeBanner: false,
      theme: LiquidGlassTheme.lightTheme,
      darkTheme: LiquidGlassTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
