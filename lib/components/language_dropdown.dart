import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:responsive_framework/responsive_framework.dart';

import '../services/internationalization.dart';

class LanguageDropdownComponent extends StatefulWidget {
  const LanguageDropdownComponent({super.key});

  @override
  State<LanguageDropdownComponent> createState() =>
      _LanguageDropdownComponentState();
}

class _LanguageDropdownComponentState extends State<LanguageDropdownComponent> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: MOBILE)],
        child: pv.Consumer<InternationalizationService>(
          builder: (context, internationalization, child) => Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
              child: DropdownButton<String>(
                underline: Container(color: Colors.transparent),
                value: internationalization.selectedItem,
                onChanged: (String? newValue) {
                  internationalization.changeLanguage(Locale(newValue!));
                },
                items: internationalization.languages
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(
                            fontSize: ResponsiveValue(context,
                                defaultValue: 15.0,
                                valueWhen: const [
                                  Condition.smallerThan(
                                      name: DESKTOP, value: 15.0)
                                ]).value,
                            fontWeight: FontWeight.bold)),
                  );
                }).toList(),
              )),
        ));
  }
}
