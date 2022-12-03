import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../services/localization.dart';

class BrandHeaderUtil extends StatefulWidget {
  const BrandHeaderUtil({super.key});

  @override
  State<BrandHeaderUtil> createState() => _BrandHeaderUtilState();
}

class _BrandHeaderUtilState extends State<BrandHeaderUtil> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: true,
      hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: TextButton(
            child: Text(
              LocalizationService.of(context)?.translate('brand_header') ?? '',
              style: TextStyle(
                  fontSize: ResponsiveValue(context,
                      defaultValue: 30.0,
                      valueWhen: const [
                        Condition.smallerThan(name: DESKTOP, value: 30.0),
                      ]).value,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        );
      }),
    );
  }
}
