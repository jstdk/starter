import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../../services/user_service.dart';

class UpdatePasswordButtonWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const UpdatePasswordButtonWidget({super.key, required this.formKey});

  @override
  State<UpdatePasswordButtonWidget> createState() =>
      _UpdatePasswordButtonWidgetState();
}

class _UpdatePasswordButtonWidgetState
    extends State<UpdatePasswordButtonWidget> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 400.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 400.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? CupertinoButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() => loader = true);
                  final response = await UserService()
                      .updatePassword(FormService.newPassword);
                  setState(() => loader = false);
                  if (response == true) {
                    if (!mounted) return;
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                          LocalizationService.of(context)?.translate(
                                  'update_password_snackbar_label') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
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
                              ?.translate('update_password_button_label') ??
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
                  final response = await UserService()
                      .updatePassword(FormService.newPassword);
                  setState(() => loader = false);
                  if (response == true) {
                    if (!mounted) return;
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                          LocalizationService.of(context)?.translate(
                                  'update_password_snackbar_label') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      loader = false;
                    });
                    if (!mounted) return;
                    final errorSnackbar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: Text(
                          LocalizationService.of(context)
                                  ?.translate('general_error_snackbar_label') ??
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
                              ?.translate('update_password_button_label') ??
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
