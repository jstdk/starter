import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../services/localization.dart';
import '../../components/go_back_button.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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

  contactUsHeader(context) {
    return ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.smallerThan(name: TABLET)],
        child: Text(
            LocalizationService.of(context)?.translate('contact_us_header') ??
                '',
            style:
                TextStyle(color: Theme.of(context).colorScheme.onBackground)));
  }

  leftSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      //hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('This is a big block of information'),
                )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  middleSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('This is a big block of information'),
                )),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: const [
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('This is a big block of information'),
                )),
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
          title: contactUsHeader(context),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.largerThan(name: MOBILE)],
                child: Text(
                    LocalizationService.of(context)
                            ?.translate('contact_us_header') ??
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
                  middleSection(),
                  rightSection(),
                ]),
            const Center(child: GoBackButtonComponent(removeAllState: false)),
          ],
        ));
  }
}
