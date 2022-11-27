import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../screens/root.dart';

class GoBackButton extends StatefulWidget {
  final bool removeAllState;
  const GoBackButton({super.key, required this.removeAllState});

  @override
  State<GoBackButton> createState() => _GoBackButtonState();
}

class _GoBackButtonState extends State<GoBackButton> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return TextButton(
          child: const Text(
            "Go back",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          onPressed: () {
            if (widget.removeAllState == true) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Root()),
                  (route) => false);
            } else {
              Navigator.pop(context);
            }
          },
        );
      }),
    );
  }
}
