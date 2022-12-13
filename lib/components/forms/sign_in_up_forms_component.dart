import 'package:flutter/material.dart';
import 'package:starter/components/buttons/sign_in_up_button_component.dart';
import 'package:starter/components/buttons/sign_in_with_google_button_component.dart';
import 'package:starter/components/form_fields/email_form_field_component.dart';
import 'package:starter/components/form_fields/password_form_field_component.dart';
import 'package:starter/components/headers/sign_in_up_header_component.dart';
import 'package:starter/components/switchers/sign_in_up_switcher_component.dart';

import '../links/reset_password_link_component.dart';
import '../sections/or_section_component.dart';

class SignInUpFormsComponent extends StatelessWidget {
  SignInUpFormsComponent({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SignInUpHeaderComponent(),
            const SizedBox(height: 40.0),
            const SignInWithGoogleButtonComponent(),
            const SizedBox(height: 30.0),
            const OrSectionComponent(),
            const SizedBox(height: 30.0),
            const EmailFormFieldComponent(email: ''),
            const SizedBox(height: 15.0),
            const PasswordFormFieldComponent(),
            const SizedBox(height: 20.0),
            SignInUpButtonComponent(formKey: formKey),
            const SizedBox(height: 20.0),
            const ResetPasswordLinkComponent(),
            const SizedBox(height: 30.0),
            const OrSectionComponent(),
            const SizedBox(height: 30.0),
            const SignInUpSwitcherComponent(),
          ],
        ));
  }
}
