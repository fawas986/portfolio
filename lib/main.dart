import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portfolio/core/theme.dart';
import 'package:portfolio/core/theme_provider.dart';
import 'package:portfolio/presentation/provider/home_provider.dart';
import 'package:portfolio/presentation/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fawaz Rahim Portfolio',
            debugShowCheckedModeBanner: false,
            // Light Theme
            theme: AppTheme.lightTheme,
            // Dark Theme
            darkTheme: AppTheme.darkTheme,
            // Current Theme Mode from Provider
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
