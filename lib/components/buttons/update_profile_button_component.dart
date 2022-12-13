import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/profile.dart';
import '../../screens/private/profile_screen.dart';
import '../../screens/root.dart';
import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/user_service.dart';

class UpdateProfileButtonComponent extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const UpdateProfileButtonComponent({super.key, required this.formKey});

  @override
  State<UpdateProfileButtonComponent> createState() =>
      _UpdateProfileButtonComponentState();
}

class _UpdateProfileButtonComponentState
    extends State<UpdateProfileButtonComponent> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            loader == true
                ? LocalizationService.of(context)
                        ?.translate('loader_button_label') ??
                    ''
                : LocalizationService.of(context)
                        ?.translate('update_profile_button_label') ??
                    '',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          // email = email ?? profile?.email;
          // fullName = fullName ?? profile?.fullName;
          // avatar = base64Avatar ?? profile?.avatar;
          if (widget.formKey.currentState!.validate()) {
            setState(() => loader = true);
            final response = await UserService().updateProfileProcedure(
                FormService.fullName, FormService.email, FormService.avatar);
            if (response == true) {
              ProfileModel? newProfile = await UserService().loadProfile();
              if (!mounted) return;
              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                content: Text(
                    LocalizationService.of(context)
                            ?.translate('update_profile_snackbar') ??
                        '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (EmailValidator.validate(newProfile!.email)) {
                if (!mounted) return;
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(profile: newProfile)),
                    (route) => false);
              } else {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Root()),
                    (route) => false);
              }
            } else {
              setState(() {
                loader = false;
              });
              if (!mounted) return;
              setState(() => {loader = false});
              final errorSnackbar = SnackBar(
                backgroundColor: Theme.of(context).colorScheme.error,
                content: Text(
                    LocalizationService.of(context)
                            ?.translate('authentication_error_message') ??
                        '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    )),
              );
              ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
            }
          } else {
            setState(() {
              loader = false;
              // error = LocalizationService.of(context)
              //         ?.translate('general_error_message') ??
              //     '';
            });
          }
        },
      ),
    );
  }
}
