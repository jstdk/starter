import 'package:flutter/material.dart';

import '../../services/localization_service.dart';

class FeaturesHeaderWidget extends StatelessWidget {
  const FeaturesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('features_header') ?? '',
        style: TextStyle(
            fontSize: 25, color: Theme.of(context).colorScheme.onBackground));
  }
}
