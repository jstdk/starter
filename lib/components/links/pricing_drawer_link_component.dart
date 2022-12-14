import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/public/pricing_screen.dart';
import '../../services/localization_service.dart';

class PricingDrawerLinkComponent extends StatelessWidget {
  final bool highlight;
  const PricingDrawerLinkComponent({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: Row(children: [
        Text(
            LocalizationService.of(context)?.translate('pricing_link_label') ??
                '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: highlight == true
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground)),
        const Spacer(),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.circleChevronRight,
            color: highlight == true
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PricingScreen(),
              ),
            );
          },
        ),
      ]),
    );
  }
}