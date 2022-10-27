import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../providers/local_authentication.dart';
import '../wrapper.dart';

class LocalAuthorization extends StatefulWidget {
  const LocalAuthorization({Key? key}) : super(key: key);

  @override
  _LocalAuthorizationState createState() => _LocalAuthorizationState();
}

class _LocalAuthorizationState extends State<LocalAuthorization> {
  //Future<dynamic> _canAuthenticate =
  //LocalAuthenticationService().checkBiometrics();
  bool hasAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Loading local authentication status from memory: ' +
          hasAuthenticated.toString());
    }

    if (hasAuthenticated == true) {
      if (kDebugMode) {
        print('The user is already authenticated using biometrics');
      }
      return const Wrapper();
    } else {
      if (kDebugMode) {
        print('The user is not yet authenticated using biometrics');
      }

      LocalAuthenticationProvider().authenticate().then((result) => setState(
          () => result == true
              ? hasAuthenticated = true
              : hasAuthenticated = false));
      if (hasAuthenticated == true) {
        if (kDebugMode) {
          print('The user is now authenticated using biometrics');
        }
        return const Wrapper();
      } else {
        if (kDebugMode) {
          print('The user could not be authenticated using biometrics');
        }
        //return LocalAuthorization();
        return Container();
      }
    }
  }
}
