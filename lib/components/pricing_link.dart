import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/public/pricing.dart';
import '../services/localization.dart';

class PricingLinkComponent extends StatefulWidget {
  const PricingLinkComponent({super.key});

  @override
  State<PricingLinkComponent> createState() => _PricingLinkComponentState();
}

class _PricingLinkComponentState extends State<PricingLinkComponent> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return TextButton(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
              LocalizationService.of(context)?.translate('pricing_link') ?? '',
              style: TextStyle(
                  fontSize: ResponsiveValue(context,
                      defaultValue: 15.0,
                      valueWhen: const [
                        Condition.smallerThan(name: DESKTOP, value: 15.0)
                      ]).value,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const PricingScreen()));
          },
        );
      }),
    );
  }
}
