import 'package:flutter/material.dart';

import '../../services/localization.dart';
import '../../utils/go_back_button.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(LocalizationService.of(context)?.translate('about_us_header') ??
            ''),
        const GoBackButtonUtil(removeAllState: false),
      ],
    ));
  }
}
