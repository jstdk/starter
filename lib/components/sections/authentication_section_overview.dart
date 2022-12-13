import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starter/components/forms/sign_in_up_forms_component.dart';

import '../../services/form_service.dart';
import '../forms/reset_password_form_component.dart';

class AuthenticationSectionOverview extends StatelessWidget {
  const AuthenticationSectionOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 40.0),
            child: Consumer<FormService>(
              builder: (context, form, child) => form.reset == false
                  ? SignInUpFormsComponent()
                  : const ResetPasswordFormComponent(),
            )));
  }
}
