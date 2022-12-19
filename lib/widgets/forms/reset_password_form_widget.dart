import 'package:flutter/material.dart';
import 'package:starter/services/form_service.dart';

import '../buttons/reset_password_button_widget.dart';
import '../form_fields/email_form_field_widget.dart';
import '../headers/reset_password_header_widget.dart';
import '../links/undo_password_reset_link_widget.dart';

class ResetPasswordFormWidget extends StatefulWidget {
  const ResetPasswordFormWidget({super.key});

  @override
  State<ResetPasswordFormWidget> createState() =>
      _ResetPasswordFormWidgetState();
}

class _ResetPasswordFormWidgetState extends State<ResetPasswordFormWidget> {
  final formKey = GlobalKey<FormState>();

  bool loading = false;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const ResetPassswordHeaderWidget(),
            const SizedBox(height: 40.0),
            const EmailFormFieldWidget(email: ''),
            const SizedBox(height: 15.0),
            ResetPasswordButtonWidget(
                formKey: formKey, email: FormService.email),
            const SizedBox(height: 30.0),
            const UndoResetLinkWidget()
          ],
        ));
  }
}
