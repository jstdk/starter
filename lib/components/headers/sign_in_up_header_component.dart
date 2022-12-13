import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class SignInUpHeaderComponent extends StatelessWidget {
  const SignInUpHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('sign_in_up_card_header') ??
            '',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold));
  }
}
