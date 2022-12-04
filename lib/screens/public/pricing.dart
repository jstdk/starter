import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization.dart';
import '../../utils/go_back_button.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  goBackIcon() {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.smallerThan(name: TABLET)],
      child: Builder(builder: (context) {
        return IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            color: Theme.of(context).colorScheme.onBackground,
            size: 20.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }),
    );
  }

  pricingHeader(context) {
    return ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.smallerThan(name: TABLET)],
        child: Text(
            LocalizationService.of(context)?.translate('pricing_header') ?? '',
            style:
                TextStyle(color: Theme.of(context).colorScheme.onBackground)));
  }

  leftSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      //hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            child: Row(
              children: [
                const Text('Open'),
              ],
            ),
          )
        ],
      ),
    ));
  }

  rightSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      //hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            child: Row(
              children: [
                Card(child: const Text('Open')),
              ],
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: goBackIcon(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: pricingHeader(context),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.largerThan(name: MOBILE)],
                child: Text(
                    LocalizationService.of(context)
                            ?.translate('pricing_header') ??
                        '',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Theme.of(context).colorScheme.onBackground))),
            ResponsiveRowColumn(
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.center,
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                rowPadding: const EdgeInsets.all(20),
                columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                children: [
                  leftSection(),
                  rightSection(),
                ]),
            const GoBackButtonUtil(removeAllState: false),
          ],
        ));
  }
}