import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

ThemeData light = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Colors.grey,
    secondary: Colors.orange,
    onSecondary: Colors.orange,
    background: Colors.white,
    error: Colors.red,
    onBackground: Colors.black,
    onError: Colors.red,
    onSurface: Colors.white,
    surface: Colors.black,
  ),
  // textTheme: const TextTheme(
  //   headline1: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  //   headline2: TextStyle(
  //       fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.blue),
  //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //   //bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  // ),
  scaffoldBackgroundColor: const Color(0xfff1f1f1),
  fontFamily: 'Nunito',
);

ThemeData dark = ThemeData(
  backgroundColor: Colors.black,
  brightness: Brightness.dark,
  primarySwatch: Colors.green,
  fontFamily: 'Nunito',
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
