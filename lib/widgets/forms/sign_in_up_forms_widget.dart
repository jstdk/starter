import 'package:flutter/material.dart';

import '../buttons/sign_in_up_button_widget.dart';
import '../buttons/sign_in_with_google_button_widget.dart';
import '../form_fields/email_form_field_widget.dart';
import '../form_fields/password_form_field_widget.dart';
import '../headers/sign_in_up_header_widget.dart';
import '../links/reset_password_link_widget.dart';
import '../sections/or_section_widget.dart';
import '../buttons/sign_in_up_switcher_button_widget.dart';

class SignInUpFormsWidget extends StatelessWidget {
  SignInUpFormsWidget({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SignInUpHeaderWidget(),
            const SizedBox(height: 40.0),
            const SignInWithGoogleButtonWidget(),
            const SizedBox(height: 30.0),
            const OrSectionWidget(),
            const SizedBox(height: 30.0),
            const EmailFormFieldWidget(email: ''),
            const SizedBox(height: 15.0),
            const PasswordFormFieldWidget(),
            const SizedBox(height: 15.0),
            SignInUpButtonWidget(formKey: formKey),
            const SizedBox(height: 20.0),
            const ResetPasswordLinkWidget(),
            const SizedBox(height: 30.0),
            const OrSectionWidget(),
            const SizedBox(height: 30.0),
            const SignInUpSwitcherButtonWidget(),
          ],
        ));
  }
}
