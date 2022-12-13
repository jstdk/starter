import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class UpdateProfileHeaderComponent extends StatelessWidget {
  const UpdateProfileHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('update_profile_header') ??
            '',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold));
  }
}
