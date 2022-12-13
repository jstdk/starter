import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class NewPasswordFormFieldComponent extends StatefulWidget {
  const NewPasswordFormFieldComponent({super.key});

  @override
  State<NewPasswordFormFieldComponent> createState() =>
      _NewPasswordFormFieldComponentState();
}

class _NewPasswordFormFieldComponentState
    extends State<NewPasswordFormFieldComponent> {
  bool obscureText = true;

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 400.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 400.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: TextFormField(
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: LocalizationService.of(context)
                      ?.translate('new_password_input_hinttext') ??
                  '',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.0,
                ),
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              labelText: LocalizationService.of(context)
                      ?.translate('new_password_input_label') ??
                  '',
              labelStyle: const TextStyle(
                fontSize: 15,
              ), //label style
              prefixIcon: const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Icon(FontAwesomeIcons.unlockKeyhole),
              ),
              suffixIcon: InkWell(
                onTap: _toggle,
                child: Icon(
                  obscureText
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  size: 20.0,
                ),
              ),
            ),
            textAlign: TextAlign.left,
            autofocus: true,
            validator: (String? value) {
              return (value != null && value.length < 2)
                  ? LocalizationService.of(context)
                          ?.translate('invalid_password_message') ??
                      ''
                  : null;
            },
            onChanged: (val) {
              setState(() => FormService.newPassword = val);
            }));
  }
}
