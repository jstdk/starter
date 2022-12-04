import 'package:flutter/material.dart';

import '../../services/localization.dart';
import '../../utils/go_back_button.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(LocalizationService.of(context)?.translate('features_header') ??
            ''),
        const GoBackButtonUtil(removeAllState: false),
      ],
    ));
  }
}