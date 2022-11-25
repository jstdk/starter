import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'public/authentication.dart';
import 'private/home.dart';

final supabase = Supabase.instance.client;

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late final StreamSubscription<AuthState> _authSubscription;
  User? user;

  @override
  void initState() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      setState(() {
        if (kDebugMode) {
          print('User auth change event occured');
        }
        user = session?.user;
      });
      if (user != null) {
        if (kDebugMode) {
          print('Navigating to HomeScreen');
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      } else {
        if (kDebugMode) {
          print('Navigating to AuthenticationScreen');
        }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const AuthenticationScreen()),
            (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = supabase.auth.currentUser;
    if (user != null) {
      if (kDebugMode) {
        print('Navigating to HomeScreen');
      }
      return const HomeScreen();
    } else {
      if (kDebugMode) {
        print('Navigating to AuthenticationScreen');
      }

      return const AuthenticationScreen();
    }
  }
}
