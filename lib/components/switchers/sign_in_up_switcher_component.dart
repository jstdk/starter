import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class SignInUpSwitcherComponent extends StatefulWidget {
  const SignInUpSwitcherComponent({super.key});

  @override
  State<SignInUpSwitcherComponent> createState() =>
      _SignInUpSwitcherComponentState();
}

class _SignInUpSwitcherComponentState extends State<SignInUpSwitcherComponent> {
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  form.toggleSignUp();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    form.signup == false
                        ? LocalizationService.of(context)
                                ?.translate('sign_up_switcher_link_label') ??
                            ''
                        : LocalizationService.of(context)
                                ?.translate('sign_in_switcher_link_label') ??
                            '',
                    style: TextStyle(
                        fontSize: ResponsiveValue(context,
                            defaultValue: 15.0,
                            valueWhen: const [
                              Condition.smallerThan(name: DESKTOP, value: 15.0),
                            ]).value,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ));
  }
}
