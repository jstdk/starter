import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivateEndDrawerComponent extends StatelessWidget {
  const PrivateEndDrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        );
      },
    );
  }
}
