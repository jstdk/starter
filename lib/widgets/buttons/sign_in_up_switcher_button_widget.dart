import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class SignInUpSwitcherButtonWidget extends StatefulWidget {
  const SignInUpSwitcherButtonWidget({super.key});

  @override
  State<SignInUpSwitcherButtonWidget> createState() =>
      _SignInUpSwitcherButtonWidgetState();
}

class _SignInUpSwitcherButtonWidgetState
    extends State<SignInUpSwitcherButtonWidget> {
  bool signup = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FormService>(
        builder: (context, form, child) => SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 300.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 300.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: (defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS)
                  ? CupertinoButton(
                      onPressed: () {
                        form.toggleSignUp();
                      },
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          form.signup == false
                              ? LocalizationService.of(context)?.translate(
                                      'sign_up_switcher_link_label') ??
                                  ''
                              : LocalizationService.of(context)?.translate(
                                      'sign_in_switcher_link_label') ??
                                  '',
                          style: TextStyle(
                              fontSize: ResponsiveValue(context,
                                  defaultValue: 15.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                        name: DESKTOP, value: 15.0),
                                  ]).value,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      onPressed: () {
                        form.toggleSignUp();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          form.signup == false
                              ? LocalizationService.of(context)?.translate(
                                      'sign_up_switcher_link_label') ??
                                  ''
                              : LocalizationService.of(context)?.translate(
                                      'sign_in_switcher_link_label') ??
                                  '',
                          style: TextStyle(
                              fontSize: ResponsiveValue(context,
                                  defaultValue: 15.0,
                                  valueWhen: const [
                                    Condition.smallerThan(
                                        name: DESKTOP, value: 15.0),
                                  ]).value,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ));
  }
}
