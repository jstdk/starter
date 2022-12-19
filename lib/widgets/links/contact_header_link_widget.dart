import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';
import '../screens/public/contact_screen_widget.dart';

class ContactHeaderLinkWidget extends StatelessWidget {
  final bool highlight;
  const ContactHeaderLinkWidget({super.key, required this.highlight});

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
              LocalizationService.of(context)
                      ?.translate('contact_us_header_link_label') ??
                  '',
              style: TextStyle(
                fontSize: ResponsiveValue(context,
                    defaultValue: 15.0,
                    valueWhen: const [
                      Condition.smallerThan(name: DESKTOP, value: 15.0)
                    ]).value,
                fontWeight: FontWeight.bold,
                decoration: highlight == true ? TextDecoration.underline : null,
                color: highlight == true
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground,
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => const ContactScreenWidget()));
            },
          ),
        );
      }),
    );
  }
}
