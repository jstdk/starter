import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/biometric_service.dart';
import '../../services/localization_service.dart';

class BiometricsDrawerSwitcherWidget extends StatelessWidget {
  const BiometricsDrawerSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android
        ? Consumer<BiometricService>(
            builder: (context, localAuthentication, child) => SwitchListTile(
              activeColor: Theme.of(context).colorScheme.primary,
              title: Text(
                LocalizationService.of(context)
                        ?.translate('biometrics_switcher_label') ??
                    '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onChanged: (value) {
                localAuthentication.toggleBiometrics();
              },
              value: localAuthentication.biometrics,
            ),
          )
        : Container();
  }
}
