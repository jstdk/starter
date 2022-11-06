import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './screens/wrapper.dart';
import './utils/theme.dart';
import './utils/local_authentication.dart';
import './screens/public/local_authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferences.setMockInitialValues({});

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeUtil()),
          ChangeNotifierProvider(create: (_) => LocalAuthenticationUtil()),
        ],
        child: Consumer<ThemeUtil>(builder: (context, ThemeUtil theme, child) {
          if (kDebugMode) {
            print('The theme is dark: $theme.darkTheme.toString()');
          }
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android) {
            return MaterialApp(
                theme: theme.darkTheme == true ? dark : light,
                builder: (context, child) => ResponsiveWrapper.builder(
                        BouncingScrollWrapper.builder(context, child!),
                        maxWidth: 1200,
                        minWidth: 450,
                        defaultScale: true,
                        breakpoints: [
                          const ResponsiveBreakpoint.resize(450, name: MOBILE),
                          const ResponsiveBreakpoint.autoScale(800,
                              name: TABLET),
                          const ResponsiveBreakpoint.autoScale(1000,
                              name: TABLET),
                          const ResponsiveBreakpoint.resize(1200,
                              name: DESKTOP),
                          const ResponsiveBreakpoint.autoScale(2460,
                              name: "4K"),
                        ]),
                home: Scaffold(body: Consumer<LocalAuthenticationUtil>(builder:
                    (context, LocalAuthenticationUtil localAuthentication,
                        child) {
                  if (kDebugMode) {
                    print(
                        'Starting app, local authentication status: $localAuthentication.biometrics.toString()');
                  }
                  if (localAuthentication.biometrics == true) {
                    return const LocalAuthenticationScreen();
                  } else {
                    return const Wrapper();
                  }
                })));
          } else {
            return MaterialApp(
                theme: theme.darkTheme == true ? dark : light,
                builder: (context, child) => ResponsiveWrapper.builder(
                        BouncingScrollWrapper.builder(context, child!),
                        maxWidth: 1200,
                        minWidth: 450,
                        defaultScale: true,
                        breakpoints: [
                          const ResponsiveBreakpoint.resize(450, name: MOBILE),
                          const ResponsiveBreakpoint.autoScale(800,
                              name: TABLET),
                          const ResponsiveBreakpoint.autoScale(1000,
                              name: TABLET),
                          const ResponsiveBreakpoint.resize(1200,
                              name: DESKTOP),
                          const ResponsiveBreakpoint.autoScale(2460,
                              name: "4K"),
                        ]),
                home: const Wrapper());
          }
        }));
  }
}
