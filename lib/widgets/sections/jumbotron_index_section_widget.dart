import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';

class JumbotronIndexSectionWidget extends StatelessWidget {
  const JumbotronIndexSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ResponsiveValue(context, defaultValue: 0.0, valueWhen: const [
                Condition.smallerThan(name: DESKTOP, value: 40.0)
              ]).value ??
              0.0,
          10.0,
          50.0,
          10.0),
      child: Column(
        children: [
          SizedBox(
            width: ResponsiveValue(context,
                defaultValue: 500.0,
                valueWhen: const [
                  Condition.smallerThan(name: DESKTOP, value: 400.0)
                ]).value,
            child: Text(
                LocalizationService.of(context)?.translate('main_tagline') ??
                    '',
                style: TextStyle(
                    fontFamily: 'OpenSansExtraBold',
                    fontSize: ResponsiveValue(context,
                        defaultValue: 50.0,
                        valueWhen: const [
                          Condition.smallerThan(name: DESKTOP, value: 40.0),
                        ]).value,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: ResponsiveValue(context,
                defaultValue: 500.0,
                valueWhen: const [
                  Condition.smallerThan(name: DESKTOP, value: 400.0)
                ]).value,
            child: Text(
                LocalizationService.of(context)?.translate('sub_tagline') ?? '',
                style: TextStyle(
                    fontSize: ResponsiveValue(context,
                        defaultValue: 25.0,
                        valueWhen: const [
                          Condition.smallerThan(name: DESKTOP, value: 20.0),
                        ]).value,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
