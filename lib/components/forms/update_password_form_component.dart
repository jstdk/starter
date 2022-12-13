import 'package:flutter/material.dart';
import 'package:starter/components/buttons/update_password_button_component.dart';
import 'package:starter/components/form_fields/new_password_again_form_field_component.dart';
import 'package:starter/components/form_fields/new_password_form_field_component.dart';
import 'package:starter/components/headers/update_password_header_component.dart';

import '../../models/profile.dart';

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
                const SizedBox(height: 20.0),
                UpdatePasswordButtonComponent(formKey: formKey),
              ],
            )),
      ),
    );
  }
}
