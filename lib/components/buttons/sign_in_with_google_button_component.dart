import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';
import '../../services/user_service.dart';

class SignInWithGoogleButtonComponent extends StatelessWidget {
  const SignInWithGoogleButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary),
        onPressed: () async {
          try {
            UserService().signInUsingGoogle();
            final snackBarSignIn = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_in_google_snackbar_label') ??
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveValue(context,
                        defaultValue: 15.0,
                        valueWhen: const [
                          Condition.smallerThan(name: DESKTOP, value: 15.0),
                        ]).value,
                    color: Colors.white,
                  )),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBarSignIn);
          } catch (e) {
            // setState(() => {
            //       loading = false,
            //       error = LocalizationService.of(context)
            //               ?.translate('general_error_message') ??
            //           ''
            //     });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            LocalizationService.of(context)
                    ?.translate('sign_in_google_button_label') ??
                '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
