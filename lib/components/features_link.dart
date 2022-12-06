import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/public/features.dart';
import '../services/localization.dart';

class FeaturesLinkComponent extends StatefulWidget {
  const FeaturesLinkComponent({super.key});

  @override
  State<FeaturesLinkComponent> createState() => _FeaturesLinkComponentState();
}

class _FeaturesLinkComponentState extends State<FeaturesLinkComponent> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: TextButton(
            child: Text(
              LocalizationService.of(context)?.translate('features_link') ?? '',
              style: TextStyle(
                  fontSize: ResponsiveValue(context,
                      defaultValue: 15.0,
                      valueWhen: const [
                        Condition.smallerThan(name: DESKTOP, value: 15.0)
                      ]).value,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => const FeaturesScreen()));
            },
          ),
        );
      }),
    );
  }
}
