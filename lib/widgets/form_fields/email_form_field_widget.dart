import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class EmailFormFieldWidget extends StatefulWidget {
  final String email;
  const EmailFormFieldWidget({super.key, required this.email});

  @override
  State<EmailFormFieldWidget> createState() => _EmailFormfieldWidgetState();
}

class _EmailFormfieldWidgetState extends State<EmailFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
              hintText: LocalizationService.of(context)
                      ?.translate('email_input_hinttext') ??
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
              labelText: LocalizationService.of(context)
                      ?.translate('email_input_label') ??
                  '',
              labelStyle: const TextStyle(
                fontSize: 15,
              ), //label style
              prefixIcon: const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Icon(FontAwesomeIcons.envelope),
              )),
          textAlign: TextAlign.left,
          initialValue: widget.email,
          autofocus: true,
          validator: (String? value) {
            return !EmailValidator.validate(value!)
                ? 'Please provide a valid email.'
                : null;
          },
          onChanged: (val) {
            setState(() => FormService.email = val);
          }),
    );
  }
}
