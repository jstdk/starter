import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/local_authentication.dart';
import '../../screens/bouncer.dart';

class LocalAuthenticationScreen extends StatefulWidget {
  const LocalAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<LocalAuthenticationScreen> createState() =>
      _LocalAuthenticationScreenState();
}

class _LocalAuthenticationScreenState extends State<LocalAuthenticationScreen> {
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
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
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
              return const Bouncer();
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
                  return const Bouncer();
                } else {
                  if (kDebugMode) {
                    print(
                        'The user could not be authenticated using biometrics');
                  }
                  //return LocalAuthorization();
                  return Container();
                }
              } else {
                print('User can NOT use local auth');
                return const Bouncer();
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
