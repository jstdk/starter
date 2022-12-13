import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/local_authentication_service.dart';
import '../../services/localization_service.dart';

class BiometricsDrawerSwitcherComponent extends StatelessWidget {
  const BiometricsDrawerSwitcherComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android
        ? Consumer<LocalAuthenticationService>(
            builder: (context, localAuthentication, child) => SwitchListTile(
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
