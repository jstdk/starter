import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

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
            Navigator.pop(context);
          },
        );
      }),
    );
  }
}
