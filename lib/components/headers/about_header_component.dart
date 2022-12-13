import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class AboutHeaderComponent extends StatelessWidget {
  const AboutHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('about_us_header') ?? '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
