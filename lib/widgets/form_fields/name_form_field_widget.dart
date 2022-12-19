import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class NameFormFieldWidget extends StatefulWidget {
  final String fullName;
  const NameFormFieldWidget({super.key, required this.fullName});

  @override
  State<NameFormFieldWidget> createState() => _NameFormFieldWidgetState();
}

class _NameFormFieldWidgetState extends State<NameFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            labelText:
                LocalizationService.of(context)?.translate('name_label') ?? '',
            labelStyle: const TextStyle(
              fontSize: 15,
            ), //label style
            prefixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(FontAwesomeIcons.faceLaugh),
            ),
            hintText: "Full name",
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
          ),
          textAlign: TextAlign.left,
          initialValue: widget.fullName,
          autofocus: true,
          validator: (String? value) {
            //print(value.length);
            return (value != null && value.length < 2)
                ? LocalizationService.of(context)
                        ?.translate('invalid_name_message') ??
                    ''
                : null;
          },
          onChanged: (val) {
            setState(() => FormService.fullName = val);
          }),
    );
  }
}
