import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PrivateDrawerIconWidget extends StatelessWidget {
  const PrivateDrawerIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.smallerThan(name: TABLET)],
        child: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronRight,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        }));
  }
}
