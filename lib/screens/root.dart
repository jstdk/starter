import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/loaders/loader_spinner_component.dart';
import '../models/profile.dart';
import '../services/localization_service.dart';
import '../services/user_service.dart';
import 'public/index_screen.dart';
import 'private/home_screen.dart';

final supabase = Supabase.instance.client;

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late final StreamSubscription<AuthState> authSubscription;
  User? user;

  @override
  void initState() {
    authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      setState(() {
        if (kDebugMode) {
          print('User auth change event!');
        }
        user = session?.user;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  Future<ProfileModel> loadProfile() async {
    return await UserService().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = supabase.auth.currentUser;
    if (user != null) {
      if (kDebugMode) {
        print('Navigating to HomeScreen');
      }
      return Scaffold(
          body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                      LocalizationService.of(context)
                              ?.translate('general_error_message') ??
                          '',
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.onBackground)));
            } else if (snapshot.hasData) {
              return HomeScreen(profile: snapshot.data);
            }
          }
          return const LoaderSpinnerComponent();
        },
        future: loadProfile(),
      ));
    } else {
      if (kDebugMode) {
        print('Navigating to AuthenticationScreen');
      }
      return const IndexScreen();
    }
    //return user == null ? const IndexScreen() : const HomeScreen();
  }
}
