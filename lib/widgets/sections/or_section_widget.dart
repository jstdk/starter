import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization_service.dart';

class OrSectionWidget extends StatelessWidget {
  const OrSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(child: Divider()),
      Text(LocalizationService.of(context)?.translate('or') ?? '',
          style: TextStyle(
            fontSize:
                ResponsiveValue(context, defaultValue: 15.0, valueWhen: const [
              Condition.smallerThan(name: DESKTOP, value: 15.0),
            ]).value,
          )),
      const Expanded(child: Divider()),
    ]);
  }
}
