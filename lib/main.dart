import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:starter/providers/local_authentication.dart';
import './screens/wrapper.dart';
import './screens/iam/local_authorization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:async';

import 'providers/user.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocalAuthenticationProvider()),
          // StreamProvider<UserProvider?>.value(
          //   value: UserProvider().user,
          //   initialData: null,
          //   catchError: (BuildContext context, e) {
          //     if (kDebugMode) {
          //       print("Error:$e");
          //     }
          //     return null;
          //   },
          // ),
        ],
        child:
            // child: Consumer<ThemeProvider>(
            //     builder: (context, ThemeProvider theme, child) {
            //   if (kDebugMode) {
            //     print('The theme is dark: ' + theme.darkTheme.toString());
            //   }
            // if (defaultTargetPlatform == TargetPlatform.iOS ||
            //     defaultTargetPlatform == TargetPlatform.android) {
            //   // return MaterialApp(
            //   //     theme: theme.darkTheme == true ? dark : light,
            //   //     home: Scaffold(body: Consumer<LocalAuthenticationProvider>(
            //   //         builder: (context,
            //   //             LocalAuthenticationProvider localAuthentication,
            //   //             child) {
            //   //       if (kDebugMode) {
            //   //         print('Starting app, local user authentication status: ' +
            //   //             localAuthentication.biometrics.toString());
            //   //       }
            //   //       if (localAuthentication.biometrics == true) {
            //   //         return const LocalAuthorization();
            //   //       } else {
            //   //         return const Wrapper();
            //   //       }
            //   //     })));
            // } else {
            AdaptiveTheme(
          light: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            accentColor: Colors.amber,
          ),
          dark: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            accentColor: Colors.amber,
          ),
          initial: AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              home: const Scaffold(body: Wrapper())),
        ));
    //}
  }
  //)

}
