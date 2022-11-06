import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'public/authentication.dart';
import 'private/home.dart';

final supabase = Supabase.instance.client;

class Bouncer extends StatefulWidget {
  const Bouncer({Key? key}) : super(key: key);

  @override
  State<Bouncer> createState() => _BouncerState();
}

class _BouncerState extends State<Bouncer> {
  late final StreamSubscription<AuthState> _authSubscription;
  User? user;

  @override
  void initState() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      //final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      setState(() {
        if (kDebugMode) {
          print('User auth change event occured. Session: $session');
        }
        user = session?.user;
      });
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
    } else {
      if (kDebugMode) {
        print('Navigating to AuthenticationScreen');
      }
    }
    return user != null ? const HomeScreen() : const AuthenticationScreen();
  }
}
