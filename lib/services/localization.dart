import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  final Locale locale;

  LocalizationService(this.locale);

  static LocalizationService? of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<LocalizationService> delegate =
      _LocalizationsServiceDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _LocalizationsServiceDelegate
    extends LocalizationsDelegate<LocalizationService> {
  const _LocalizationsServiceDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'nl'].contains(locale.languageCode);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    LocalizationService localizations = LocalizationService(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_LocalizationsServiceDelegate old) => false;
}
