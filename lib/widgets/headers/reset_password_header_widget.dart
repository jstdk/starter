import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class ResetPassswordHeaderWidget extends StatelessWidget {
  const ResetPassswordHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('reset_password_header') ??
            '',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold));
  }
}
