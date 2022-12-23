import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../drop_downs/language_header_dropdown_widget.dart';
import '../../headers/pricing_header_widget.dart';
import '../../headers/public_drawer_header_widget.dart';
import '../../icons/public_drawer_icon_widget.dart';
import '../../icons/theme_header_icon_widget.dart';
import '../../links/about_drawer_link_widget.dart';
import '../../links/about_header_link_widget.dart';
import '../../links/faq_drawer_link_widget.dart';
import '../../links/faq_header_link_widget.dart';
import '../../links/features_drawer_link_widget.dart';
import '../../links/features_header_link_widget.dart';
import '../../links/logo_header_link_widget.dart';
import '../../links/pricing_drawer_link_widget.dart';
import '../../links/pricing_header_link_widget.dart';

class PricingScreenWidget extends StatelessWidget {
  const PricingScreenWidget({super.key});

  leftSection(context) {
    return ResponsiveRowColumnItem(
        rowFlex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: const [
                  Card(
                      child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                        Text('This is a big block of information blablablabla'),
                  )),
                ],
              ),
            )
          ],
        ));
  }

  middleSection() {
    return ResponsiveRowColumnItem(
        rowFlex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
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
        ));
  }

  rightSection() {
    return ResponsiveRowColumnItem(
        rowFlex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
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
        ));
  }

  drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          PublicDrawerHeaderWidget(),
          SizedBox(height: 20.0),
          FeaturesDrawerLinkWidget(highlight: false),
          SizedBox(height: 5.0),
          PricingDrawerLinkWidget(highlight: true),
          SizedBox(height: 5.0),
          FaqDrawerLinkWidget(highlight: false),
          SizedBox(height: 5.0),
          AboutDrawerLinkWidget(highlight: false)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(
              ResponsiveValue(context, defaultValue: 15.0, valueWhen: const [
                    Condition.smallerThan(name: TABLET, value: 5.0)
                  ]).value ??
                  15.0,
              0.0,
              0.0,
              0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              PublicDrawerIconWidget(),
              LogoHeaderLinkWidget()
            ],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [
          FeaturesHeaderLinkWidget(highlight: false),
          PricingHeaderLinkWidget(highlight: true),
          AboutUsHeaderLinkWidget(highlight: false),
          FaqHeaderLinkWidget(highlight: false),
          LanguageHeaderDropdownWidget(),
          ThemeHeaderIconWidget(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const PricingHeaderWidget(),
          ResponsiveRowColumn(
              layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.center,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              rowPadding: const EdgeInsets.all(20),
              columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              children: [
                leftSection(context),
                middleSection(),
                rightSection(),
              ]),
        ],
      ),
      drawer: drawer(),
    );
  }
}
