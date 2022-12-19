import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../main.dart';

class GoBackLinkWidget extends StatelessWidget {
  final bool removeState;
  final String label;
  const GoBackLinkWidget(
      {super.key, required this.removeState, required this.label});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(FontAwesomeIcons.circleChevronLeft,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () async {
                  if (removeState == true) {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const App()),
                            (route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                }),
            const SizedBox(
              width: 5,
            ),
            Text(label)
          ],
        );
      }),
    );
  }
}
