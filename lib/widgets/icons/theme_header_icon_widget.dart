import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/theme_service.dart';

class ThemeHeaderIconWidget extends StatelessWidget {
  const ThemeHeaderIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<ThemeService>(
        builder: (context, theme, child) => theme.darkTheme == true
            ? Padding(
                padding: EdgeInsets.fromLTRB(
                    20.0,
                    10.0,
                    ResponsiveValue(context,
                            defaultValue: 50.0,
                            valueWhen: const [
                              Condition.smallerThan(name: TABLET, value: 10.0)
                            ]).value ??
                        50.0,
                    0.0),
                child: IconButton(
                    icon: Icon(
                      (defaultTargetPlatform == TargetPlatform.iOS ||
                              defaultTargetPlatform == TargetPlatform.macOS)
                          ? CupertinoIcons.sun_max
                          : FontAwesomeIcons.sun,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () => theme.toggleTheme()),
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    10,
                    ResponsiveValue(context,
                            defaultValue: 50.0,
                            valueWhen: const [
                              Condition.smallerThan(name: TABLET, value: 0.0)
                            ]).value ??
                        50.0,
                    0),
                child: IconButton(
                    icon: Icon(
                        (defaultTargetPlatform == TargetPlatform.iOS ||
                                defaultTargetPlatform == TargetPlatform.macOS)
                            ? CupertinoIcons.moon
                            : FontAwesomeIcons.moon,
                        color: Theme.of(context).colorScheme.onBackground),
                    onPressed: () => theme.toggleTheme()),
              ));
  }
}
