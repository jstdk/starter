import 'package:adaptive_theme/adaptive_theme.dart';
import './screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://dfymjnonymnyxvsobdmk.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmeW1qbm9ueW1ueXh2c29iZG1rIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjQ2OTI1OTYsImV4cCI6MTk4MDI2ODU5Nn0.Nesx82ZmTvBu5N3aP6gYasbcpIiknQ9q5cctQ0rudjo');

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
          home: const Scaffold(body: Wrapper())),
    );
    //}
  }
  //)

}
