import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class InternationalizationService extends ChangeNotifier {
  late Locale _locale;

  String? selectedItem;

  List<String> languages = [
    'en',
    'nl',
  ];

  Locale get locale => _locale;

  InternationalizationService() {
    _locale = const Locale('en');
    loadFromPrefs();
  }

  loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tempLocale = prefs.getString('language_code') ?? 'en';
    _locale = Locale(tempLocale);
    selectedItem = tempLocale;
    if (kDebugMode) {
      print('Locale loaded from storage. Locale is: $tempLocale');
    }
    notifyListeners();
  }

  saveToPrefs(Locale localeToSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (localeToSet == const Locale("nl")) {
      _locale = const Locale("nl");
      await prefs.setString('language_code', 'nl');
      await prefs.setString('country_code', '');
    } else {
      _locale = const Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('country_code', 'US');
    }
    if (kDebugMode) {
      print('Locale saved to storage. Locale is: $localeToSet');
    }
    notifyListeners();
  }

  void changeLanguage(Locale type) async {
    selectedItem = type.toString();
    saveToPrefs(type);
  }
}
