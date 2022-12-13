import 'package:flutter/material.dart';
import 'package:starter/components/buttons/reset_password_button_component.dart';
import 'package:starter/components/form_fields/email_form_field_component.dart';
import 'package:starter/components/links/undo_password_reset_link_component.dart';
import 'package:starter/services/form_service.dart';

import '../headers/reset_password_header_component.dart';

class ResetPasswordFormComponent extends StatefulWidget {
  const ResetPasswordFormComponent({super.key});

  @override
  State<ResetPasswordFormComponent> createState() =>
      _ResetPasswordFormComponentState();
}

class _ResetPasswordFormComponentState
    extends State<ResetPasswordFormComponent> {
  final formKey = GlobalKey<FormState>();

  bool loading = false;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const ResetPassswordHeaderComponent(),
            const SizedBox(height: 40.0),
            const EmailFormFieldComponent(email: ''),
            const SizedBox(height: 20.0),
            ResetPasswordButtonComponent(
                formKey: formKey, email: FormService.email),
            const SizedBox(height: 30.0),
            const UndoResetLinkComponent()
          ],
        ));
  }
}
