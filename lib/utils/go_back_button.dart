import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/root.dart';
import '../services/localization.dart';

class GoBackButtonUtil extends StatefulWidget {
  final bool removeAllState;
  const GoBackButtonUtil({super.key, required this.removeAllState});

  @override
  State<GoBackButtonUtil> createState() => _GoBackButtonUtilState();
}

class _GoBackButtonUtilState extends State<GoBackButtonUtil> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return Row(
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
