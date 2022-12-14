import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/headers/pricing_header_component.dart';

import '../../components/links/about_drawer_link_component.dart';
import '../../components/links/about_header_link_component.dart';
import '../../components/links/faq_drawer_link_component.dart';
import '../../components/links/faq_header_link_component.dart';
import '../../components/links/features_drawer_link_component.dart';
import '../../components/links/features_header_link_component.dart';
import '../../components/dropdowns/language_header_dropdown_component.dart';
import '../../components/links/logo_header_link_component.dart';
import '../../components/links/pricing_drawer_link_component.dart';
import '../../components/links/pricing_header_link_component.dart';
import '../../components/headers/public_drawer_header_component.dart';
import '../../components/icons/public_drawer_icon_component.dart';
import '../../components/icons/theme_header_icon_component.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

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
          PublicDrawerHeaderComponent(),
          SizedBox(height: 20.0),
          FeaturesDrawerLinkComponent(highlight: false),
          SizedBox(height: 5.0),
          PricingDrawerLinkComponent(highlight: true),
          SizedBox(height: 5.0),
          FaqDrawerLinkComponent(highlight: false),
          SizedBox(height: 5.0),
          AboutDrawerLinkComponent(highlight: false)
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
              PublicDrawerIconComponent(),
              LogoHeaderLinkComponent()
            ],
          ),
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [
          FeaturesHeaderLinkComponent(highlight: false),
          PricingHeaderLinkComponent(highlight: true),
          AboutUsHeaderLinkComponent(highlight: false),
          FaqHeaderLinkComponent(highlight: false),
          LanguageHeaderDropdownComponent(),
          ThemeHeaderIconComponent(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const PricingHeaderComponent(),
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