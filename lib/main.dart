import './screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Initiate Supabase
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_KEY']!);

  runApp(const StarterApp());
}

class StarterApp extends StatefulWidget {
  const StarterApp({Key? key}) : super(key: key);

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const Wrapper(),
      ),
    );
  }
}
