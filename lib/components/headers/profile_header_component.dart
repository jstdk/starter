import 'package:flutter/material.dart';
import '../../services/localization_service.dart';

class ProfileHeaderComponent extends StatelessWidget {
  const ProfileHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        LocalizationService.of(context)?.translate('profile_header') ?? '',
        style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold));
  }
}
