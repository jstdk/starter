import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/form_service.dart';
import '../../services/localization_service.dart';

class ResetPasswordLinkWidget extends StatelessWidget {
  const ResetPasswordLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FormService>(
        builder: (context, form, child) => GestureDetector(
            child: Text(
                LocalizationService.of(context)
                        ?.translate('reset_password_link_label') ??
                    '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              form.toggleReset();
            }));
  }
}
