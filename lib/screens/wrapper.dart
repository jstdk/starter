import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'public/sign_in.dart';
import 'private/home.dart';

final supabase = Supabase.instance.client;

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final StreamSubscription<AuthState> _authSubscription;
  User? user;

  @override
  void initState() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      //final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      setState(() {
        if (kDebugMode) {
          print('User auth change event occured');
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
        print('Navigating to LoginScreen');
      }
    }
    return user != null ? const HomeScreen() : const SignInScreen();
  }
}
