import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../utils/local_authentication.dart';
import '../../screens/wrapper.dart';
import '../../utils/loading.dart';

class LocalAuthenticationScreen extends StatefulWidget {
  const LocalAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<LocalAuthenticationScreen> createState() =>
      _LocalAuthenticationScreenState();
}

class _LocalAuthenticationScreenState extends State<LocalAuthenticationScreen> {
  bool hasAuthenticated = false;

  Future<dynamic> getData() async {
    final isAvailable = LocalAuthenticationUtil().checkBiometrics;
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
                style: TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            String message = hasAuthenticated.toString();
            print(message);

            if (hasAuthenticated == true) {
              if (kDebugMode) {
                print('The user is already authenticated using biometrics');
              }
              return const Wrapper();
            } else {
              if (kDebugMode) {
                print('The user is not yet authenticated using biometrics');
              }
              if (snapshot.data == true) {
                LocalAuthenticationUtil().authenticate().then((result) =>
                    setState(() => result == true
                        ? hasAuthenticated = true
                        : hasAuthenticated = false));
                if (hasAuthenticated == true) {
                  if (kDebugMode) {
                    print('The user is now authenticated using biometrics');
                  }
                  return const Wrapper();
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
                return Wrapper();
              }
            }
          }
        }
        return const Loading();
      },
      future: getData(),
    ));
  }
}
