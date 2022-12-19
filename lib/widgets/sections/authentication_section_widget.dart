import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starter/widgets/forms/sign_in_up_forms_widget.dart';

import '../../services/form_service.dart';
import '../forms/reset_password_form_widget.dart';

class AuthenticationSectionOverviewWidget extends StatelessWidget {
  const AuthenticationSectionOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 40.0),
            child: Consumer<FormService>(
              builder: (context, form, child) => form.reset == false
                  ? SignInUpFormsWidget()
                  : const ResetPasswordFormWidget(),
            )));
  }
}
