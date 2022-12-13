import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/buttons/update_password_button_component.dart';
import 'package:starter/components/formfields/new_password_again_form_field_component.dart';
import 'package:starter/components/formfields/new_password_form_field_component.dart';
import 'package:starter/components/headers/update_password_header_component.dart';
import 'package:starter/services/form_service.dart';

import '../../models/profile.dart';
import '../../services/localization_service.dart';
import '../../services/user_service.dart';

class UpdatePasswordFormComponent extends StatefulWidget {
  final ProfileModel? profile;

  const UpdatePasswordFormComponent({super.key, this.profile});

  @override
  State<UpdatePasswordFormComponent> createState() =>
      _UpdatePasswordFormComponentState();
}

class _UpdatePasswordFormComponentState
    extends State<UpdatePasswordFormComponent> {
  final formKey = GlobalKey<FormState>();
  bool loader = false;

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
                const UpdatePasswordHeaderComponent(),
                const SizedBox(height: 40.0),
                const NewPasswordFormFieldComponent(),
                const SizedBox(height: 20.0),
                const NewPasswordAgainFormFieldComponent(),
                const SizedBox(height: 5),
                UpdatePasswordButtonComponent(formKey: formKey),
              ],
            )),
      ),
    );
  }
}
