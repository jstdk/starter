import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/builders/home_screen_future_builder_component.dart';
import 'public/index_screen.dart';

final supabase = Supabase.instance.client;

class Bouncer extends StatefulWidget {
  const Bouncer({super.key});

  @override
  State<Bouncer> createState() => _BouncerState();
}

class _BouncerState extends State<Bouncer> {
  Session? session;
  StreamSubscription<AuthState>? authSubscription;

  @override
  void initState() {
    authSubscription = supabase.auth.onAuthStateChange.listen((response) {
      if (kDebugMode) {
        print('AuthEvent recorded');
      }
      setState(() {
        session = response.session;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    session = supabase.auth.currentSession;
    return session == null
        ? const IndexScreen()
        : const HomeScreenFutureBuilderComponent();
  }
}
