import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

ThemeData light = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.black,
    background: Colors.transparent,
    error: Colors.red,
    onBackground: Color.fromARGB(255, 98, 98, 98),
    onError: Colors.red,
    onSurface: Color.fromARGB(255, 236, 236, 236),
    surface: Colors.black,
  ),
  fontFamily: 'OpenSans',
);

ThemeData dark = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.green,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.black,
    background: Colors.transparent,
    error: Colors.red,
    onBackground: Colors.white,
    onError: Colors.red,
    onSurface: Color.fromARGB(255, 78, 78, 78),
    surface: Colors.black,
  ),
  fontFamily: 'OpenSans',
);

class ThemeService extends ChangeNotifier {
  final String key = "theme";
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeService() {
    _darkTheme = SystemTheme.isDarkMode;
    loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    saveToPrefs();
  }

  loadFromPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darkTheme = pref.getBool(key) ?? SystemTheme.isDarkMode;
    if (kDebugMode) {
      print('Theme loaded from storage. DarkTheme is: $_darkTheme');
    }
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, _darkTheme);
    if (kDebugMode) {
      print('Theme saved in storage. DarkTheme is: $_darkTheme');
    }
    notifyListeners();
  }
}
