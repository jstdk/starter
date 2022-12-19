import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/localization_service.dart';
import '../screens/public/about_screen_widget.dart';

class AboutDrawerLinkWidget extends StatelessWidget {
  final bool highlight;
  const AboutDrawerLinkWidget({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: Row(children: [
        Text(
            LocalizationService.of(context)?.translate('about_us_link_label') ??
                '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlight == true
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            )),
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
                builder: (context) => const AboutScreenWidget(),
              ),
            );
          },
        ),
      ]),
    );
  }
}
