import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PublicDrawerIconWidget extends StatelessWidget {
  const PublicDrawerIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.smallerThan(name: TABLET)],
      child: Builder(builder: (context) {
        return IconButton(
          icon: Icon(
            (defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.macOS)
                ? CupertinoIcons.bars
                : FontAwesomeIcons.bars,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
    );
  }
}
