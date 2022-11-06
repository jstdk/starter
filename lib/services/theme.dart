import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  scaffoldBackgroundColor: const Color(0xfff1f1f1),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
);

class ThemeService extends ChangeNotifier {
  final String key = "theme";
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeService() {
    _darkTheme = false;
    loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    saveToPrefs();
  }

  loadFromPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darkTheme = pref.getBool(key) ?? true;
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, _darkTheme);
    notifyListeners();
  }
}
