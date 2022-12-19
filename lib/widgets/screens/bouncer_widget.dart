import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../builders/home_screen_future_builder_widget.dart';
import 'public/index_screen_widget.dart';

final supabase = Supabase.instance.client;

class BouncerWidget extends StatefulWidget {
  const BouncerWidget({super.key});

  @override
  State<BouncerWidget> createState() => _BouncerWidgetState();
}

class _BouncerWidgetState extends State<BouncerWidget> {
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
        ? const IndexScreenWidget()
        : const HomeScreenFutureBuilderWidget();
  }
}
