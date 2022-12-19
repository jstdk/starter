import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/local_authentication_service.dart';

class LocalAuthenticationScreenWidget extends StatefulWidget {
  const LocalAuthenticationScreenWidget({Key? key}) : super(key: key);

  @override
  State<LocalAuthenticationScreenWidget> createState() =>
      _LocalAuthenticationScreenWidgetState();
}

class _LocalAuthenticationScreenWidgetState
    extends State<LocalAuthenticationScreenWidget> {
  bool hasAuthenticated = false;

  Future<dynamic> checkBiometrics() async {
    final isAvailable = LocalAuthenticationService().checkBiometrics();
    return isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            String localAuthenticationStatus = hasAuthenticated.toString();
            if (kDebugMode) {
              print('Local authentication status $localAuthenticationStatus');
            }
            if (hasAuthenticated == true) {
              if (kDebugMode) {
                print('The user is already authenticated using biometrics');
              }
              return const App();
            } else {
              if (kDebugMode) {
                print('The user is not yet authenticated using biometrics');
              }
              if (snapshot.data == true) {
                LocalAuthenticationService().authenticate().then((result) =>
                    setState(() => result == true
                        ? hasAuthenticated = true
                        : hasAuthenticated = false));
                if (hasAuthenticated == true) {
                  if (kDebugMode) {
                    print('The user is now authenticated using biometrics');
                  }
                  return const App();
                } else {
                  if (kDebugMode) {
                    print(
                        'The user could not be authenticated using biometrics');
                  }
                  return Container();
                }
              } else {
                if (kDebugMode) {
                  print('User can NOT use local auth');
                }
                return const App();
              }
            }
          }
        }
        return const CircularProgressIndicator();
      },
      future: checkBiometrics(),
    ));
  }
}
