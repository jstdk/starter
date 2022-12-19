import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/services/form_service.dart';

import '../../services/localization_service.dart';

class NewPasswordAgainFormFieldWidget extends StatefulWidget {
  const NewPasswordAgainFormFieldWidget({super.key});

  @override
  State<NewPasswordAgainFormFieldWidget> createState() =>
      _NewPasswordAgainFormFieldWidgetState();
}

class _NewPasswordAgainFormFieldWidgetState
    extends State<NewPasswordAgainFormFieldWidget> {
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
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),

          // style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: LocalizationService.of(context)
                    ?.translate('new_password_again_input_hinttext') ??
                '',
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                    ?.translate('new_password_again_input_label') ??
                '',
            labelStyle: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.secondary,
            ), //label style
            prefixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(FontAwesomeIcons.unlockKeyhole),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: InkWell(
                onTap: _toggle,
                child: Icon(
                  obscureText
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  size: 20.0,
                ),
              ),
            ),
          ),
          textAlign: TextAlign.left,
          autofocus: false,
          validator: (String? value) {
            return (value != FormService.newPassword)
                ? LocalizationService.of(context)
                        ?.translate('invalid_password_again_message') ??
                    ''
                : null;
          },
          onChanged: (val) {
            setState(() => FormService.newPasswordAgain = val);
          }),
    );
  }
}
