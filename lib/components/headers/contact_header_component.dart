import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class ContactHeaderComponent extends StatelessWidget {
  const ContactHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('contact_us_header') ?? '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
