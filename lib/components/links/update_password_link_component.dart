import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/profile_model.dart';
import '../../screens/private/update_password_screen..dart';
import '../../services/localization_service.dart';

class UpdatePasswordLinkComponent extends StatelessWidget {
  final ProfileModel? profile;
  const UpdatePasswordLinkComponent({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 300.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(LocalizationService.of(context)
                      ?.translate('update_password_button_label') ??
                  ''),
            ),
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UpdatePasswordScreen(profile: profile),
                  ))
                }));
  }
}
