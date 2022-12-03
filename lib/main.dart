import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './screens/root.dart';
import './services/theme.dart';
import './services/local_authentication.dart';
import './services/internationalization.dart';
import './services/localization.dart';
import './screens/public/local_authentication.dart';

// * Initialize app
Future<void> main() async {
  // Initial setup
  WidgetsFlutterBinding.ensureInitialized();

  // Load .envv
  await dotenv.load(fileName: ".env");

  // Initiate Supabase using .env
  HiveLocalStorage.encryptionKey = dotenv.env["SUPABASE_SECURE_KEY"];
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
    storageRetryAttempts: 25,
  );

  // Run the app
  runApp(const StarterApp());
}

// App class
class StarterApp extends StatelessWidget {
  const StarterApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => LocalAuthenticationService()),
          ChangeNotifierProvider(create: (_) => InternationalizationService()),
        ],
        child: Consumer3<ThemeService, InternationalizationService,
                LocalAuthenticationService>(
            builder: (context,
                ThemeService theme,
                InternationalizationService internationalization,
                LocalAuthenticationService localAuthentication,
                child) {
          return MaterialApp(
              theme: theme.darkTheme == true ? dark : light,
              locale: internationalization.locale,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('nl', ''),
              ],
              localizationsDelegates: const [
                LocalizationService.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode &&
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              builder: (context, child) => ResponsiveWrapper.builder(
                      BouncingScrollWrapper.builder(context, child!),
                      minWidth: 450,
                      defaultScale: true,
                      breakpoints: [
                        const ResponsiveBreakpoint.resize(450, name: MOBILE),
                        const ResponsiveBreakpoint.resize(800, name: TABLET),
                        const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                      ]),
              home: SafeArea(
                child: Scaffold(
                    body: (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.android)
                        ? localAuthentication.biometrics == true
                            ? const LocalAuthenticationScreen()
                            : const Root()
                        : const Root()),
              ));
        }));
  }
}
