import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class PricingHeaderWidget extends StatelessWidget {
  const PricingHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('pricing_header') ?? '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
