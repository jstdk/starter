import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/profile_model.dart';
import '../../services/form_service.dart';
import '../../services/localization_service.dart';
import '../buttons/update_profile_button_widget.dart';
import '../form_fields/avatar_form_field_widget.dart';
import '../form_fields/email_form_field_widget.dart';
import '../form_fields/name_form_field_widget.dart';
import '../headers/profile_header_widget.dart';

class UpdateProfileFormWidget extends StatefulWidget {
  final ProfileModel? profile;
  final Uint8List? avatarBytes;

  const UpdateProfileFormWidget(
      {super.key, required this.profile, this.avatarBytes});

  @override
  State<UpdateProfileFormWidget> createState() =>
      _UpdateProfileFormWidgetState();
}

class _UpdateProfileFormWidgetState extends State<UpdateProfileFormWidget> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  emailFormField(profile) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 450.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 450.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            labelText: LocalizationService.of(context)
                    ?.translate('email_input_label') ??
                '',
            labelStyle: const TextStyle(
              fontSize: 15,
            ), //label style
            prefixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(FontAwesomeIcons.envelope),
            ),
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
          ),
          textAlign: TextAlign.left,
          initialValue: profile!.email,
          autofocus: true,
          validator: (String? value) {
            return !EmailValidator.validate(value!)
                ? LocalizationService.of(context)
                        ?.translate('invalid_email_message') ??
                    ''
                : null;
          },
          onChanged: (val) {
            setState(() => FormService.email = val);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const ProfileHeaderWidget(),
                const SizedBox(height: 30.0),
                AvatarFormFieldWidget(avatarBytes: widget.avatarBytes),
                const SizedBox(height: 50.0),
                EmailFormFieldWidget(email: widget.profile!.email),
                const SizedBox(height: 15),
                NameFormFieldWidget(fullName: widget.profile!.fullName),
                const SizedBox(height: 15.0),
                UpdateProfileButtonWidget(formKey: formKey)
              ],
            )),
      ),
    );
  }
}
