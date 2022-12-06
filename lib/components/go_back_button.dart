import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/root.dart';
import '../services/localization.dart';

class GoBackButtonComponent extends StatefulWidget {
  final bool removeAllState;
  const GoBackButtonComponent({super.key, required this.removeAllState});

  @override
  State<GoBackButtonComponent> createState() => _GoBackButtonComponentState();
}

class _GoBackButtonComponentState extends State<GoBackButtonComponent> {
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
                icon: const Icon(
                  FontAwesomeIcons.circleChevronLeft,
                ),
                onPressed: () async {
                  if (widget.removeAllState == true) {
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Root()),
                            (route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                }),
            const SizedBox(
              width: 5,
            ),
            Text(
                LocalizationService.of(context)?.translate('go_back_link') ??
                    '',
                style: const TextStyle(fontSize: 15))
          ],
        );
      }),
    );
  }
}
