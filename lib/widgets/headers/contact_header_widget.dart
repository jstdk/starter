import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class ContactHeaderWidget extends StatelessWidget {
  const ContactHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('contact_us_header') ?? '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
