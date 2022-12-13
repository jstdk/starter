import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class FaqHeaderComponent extends StatelessWidget {
  const FaqHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(LocalizationService.of(context)?.translate('faq_header') ?? '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
