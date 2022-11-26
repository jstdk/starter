import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.green,
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
