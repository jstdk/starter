import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class UpdatePasswordHeaderComponent extends StatelessWidget {
  const UpdatePasswordHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('update_password_header') ??
            '',
        style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold));
  }
}
