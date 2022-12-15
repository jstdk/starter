import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:starter/services/form_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/bouncer.dart';
import 'services/theme_service.dart';
import 'services/local_authentication_service.dart';
import 'services/internationalization_service.dart';
import 'services/localization_service.dart';
import 'screens/public/local_authentication_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  HiveLocalStorage.encryptionKey = dotenv.env["SUPABASE_SECURE_KEY"];
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );

  runApp(const StarterApp());
}

class StarterApp extends StatelessWidget {
  const StarterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => LocalAuthenticationService()),
          ChangeNotifierProvider(create: (_) => InternationalizationService()),
          ChangeNotifierProvider(create: (_) => FormService()),
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
              builder: (context, child) => ResponsiveWrapper.builder(
                    BouncingScrollWrapper.builder(context, child!),
                    maxWidth: 1200,
                    minWidth: 450,
                    breakpoints: [
                      const ResponsiveBreakpoint.resize(450, name: MOBILE),
                      const ResponsiveBreakpoint.resize(800, name: TABLET),
                      const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                    ],
                    background: Container(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
              home: SafeArea(
                  child: Scaffold(
                      body: (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.android)
                          ? localAuthentication.biometrics == true
                              ? const LocalAuthenticationScreen()
                              : const Bouncer()
                          : const Bouncer())));
        }));
  }
}
