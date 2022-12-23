import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../main.dart';
import '../../models/profile_model.dart';
import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/user_service.dart';
import '../screens/private/profile_screen_widget.dart';

class UpdateProfileButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const UpdateProfileButtonWidget({super.key, required this.formKey});

  @override
  State<UpdateProfileButtonWidget> createState() =>
      _UpdateProfileButtonWidgetState();
}

class _UpdateProfileButtonWidgetState extends State<UpdateProfileButtonWidget> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? CupertinoButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  final response = await UserService().updateProfileProcedure(
                      FormService.fullName,
                      FormService.email,
                      FormService.avatar);
                  if (response == true) {
                    ProfileModel? newProfile =
                        await UserService().loadProfile();
                    if (!mounted) return;
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                          LocalizationService.of(context)
                                  ?.translate('update_profile_snackbar') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (EmailValidator.validate(newProfile!.email)) {
                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreenWidget(profile: newProfile)),
                              (route) => false);
                    } else {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const App()),
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
                                  ?.translate('general_error_snackbar_label') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
                  }
                } else {
                  setState(() {
                    loader = false;
                  });
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
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
            )
          : ElevatedButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  final response = await UserService().updateProfileProcedure(
                      FormService.fullName,
                      FormService.email,
                      FormService.avatar);
                  if (response == true) {
                    ProfileModel? newProfile =
                        await UserService().loadProfile();
                    if (!mounted) return;
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                          LocalizationService.of(context)
                                  ?.translate('update_profile_snackbar') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (EmailValidator.validate(newProfile!.email)) {
                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreenWidget(profile: newProfile)),
                              (route) => false);
                    } else {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const App()),
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
                                  ?.translate('general_error_snackbar_label') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(errorSnackbar);
                  }
                } else {
                  setState(() {
                    loader = false;
                  });
                }
              },
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
            ),
    );
  }
}
