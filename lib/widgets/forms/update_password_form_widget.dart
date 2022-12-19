import 'package:flutter/material.dart';

import '../../models/profile_model.dart';
import '../buttons/update_password_button_widget.dart';
import '../form_fields/new_password_again_form_field_widget.dart';
import '../form_fields/new_password_form_field_widget.dart';
import '../headers/update_password_header_widget.dart';

class UpdatePasswordFormWidget extends StatefulWidget {
  final ProfileModel? profile;

  const UpdatePasswordFormWidget({super.key, this.profile});

  @override
  State<UpdatePasswordFormWidget> createState() =>
      _UpdatePasswordFormWidgetState();
}

class _UpdatePasswordFormWidgetState extends State<UpdatePasswordFormWidget> {
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
                const UpdatePasswordHeaderWidget(),
                const SizedBox(height: 40.0),
                const NewPasswordFormFieldWidget(),
                const SizedBox(height: 15.0),
                const NewPasswordAgainFormFieldWidget(),
                const SizedBox(height: 15.0),
                UpdatePasswordButtonWidget(formKey: formKey),
              ],
            )),
      ),
    );
  }
}
