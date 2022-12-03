import 'package:flutter/material.dart';

import '../../services/localization.dart';
import '../../utils/go_back_button.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text(LocalizationService.of(context)?.translate('contact_us_header') ??
            ''),
        const GoBackButtonUtil(removeAllState: false),
      ],
    ));
  }
}
