import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class PrivateEndDrawerHeaderWidget extends StatelessWidget {
  const PrivateEndDrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Text(
          LocalizationService.of(context)?.translate('settings_header') ?? '',
          style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
    );
  }
}
