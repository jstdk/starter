import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/public/contact_us.dart';
import '../services/localization.dart';

class ContactUsLinkComponent extends StatefulWidget {
  const ContactUsLinkComponent({super.key});

  @override
  State<ContactUsLinkComponent> createState() => _ContactUsLinkComponentState();
}

class _ContactUsLinkComponentState extends State<ContactUsLinkComponent> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 50, 0),
          child: TextButton(
            child: Text(
              LocalizationService.of(context)?.translate('contact_us_link') ??
                  '',
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
                  builder: (context) => const ContactUsScreen()));
            },
          ),
        );
      }),
    );
  }
}
