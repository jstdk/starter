import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/links/features_drawer_link_component.dart';
import 'package:starter/components/jumbotrons/jumbotron_index_component.dart';
import 'package:starter/components/links/pricing_drawer_link_component.dart';
import 'package:starter/components/headers/public_drawer_header_component.dart';
import 'package:starter/components/icons/public_drawer_icon_component.dart';
import 'package:starter/components/sections/authentication_section_overview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/links/about_drawer_link_component.dart';
import '../../components/links/about_header_link_component.dart';
import '../../components/links/faq_drawer_link_component.dart';
import '../../components/links/faq_header_link_component.dart';
import '../../components/dropdowns/language_header_dropdown_component.dart';
import '../../components/links/pricing_header_link_component.dart';
import '../../components/icons/theme_header_icon_component.dart';
import '../../components/links/logo_header_link_component.dart';
import '../../components/links/features_header_link_component.dart';
import '../../components/loaders/loader_spinner_component.dart';

final supabase = Supabase.instance.client;

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  bool loading = false;

  drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PublicDrawerHeaderComponent(),
          const SizedBox(height: 20.0),
          const FeaturesDrawerLinkComponent(highlight: false),
          Divider(color: Theme.of(context).colorScheme.onBackground),
          const PricingDrawerLinkComponent(highlight: false),
          Divider(color: Theme.of(context).colorScheme.onBackground),
          const FaqDrawerLinkComponent(highlight: false),
          Divider(color: Theme.of(context).colorScheme.onBackground),
          const AboutDrawerLinkComponent(highlight: false)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoaderSpinnerComponent()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.fromLTRB(
                    ResponsiveValue(context,
                            defaultValue: 15.0,
                            valueWhen: const [
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
                PricingHeaderLinkComponent(highlight: false),
                AboutUsHeaderLinkComponent(highlight: false),
                FaqHeaderLinkComponent(highlight: false),
                LanguageHeaderDropdownComponent(),
                ThemeHeaderIconComponent(),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveValue(context,
                            defaultValue: 30.0,
                            valueWhen: const [
                              Condition.smallerThan(name: DESKTOP, value: 15.0),
                            ]).value ??
                        30.0,
                  ),
                  ResponsiveRowColumn(
                    layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: ResponsiveVisibility(
                            hiddenWhen: const [
                              Condition.smallerThan(name: TABLET)
                            ],
                            child: Column(
                              children: const [
                                JumbotronComponent(),
                              ],
                            ),
                          )),
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                width: ResponsiveValue(context,
                                    defaultValue: 450.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                          name: MOBILE, value: 450.0),
                                      Condition.smallerThan(
                                          name: TABLET, value: double.infinity)
                                    ]).value,
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        8.0,
                                        30.0,
                                        ResponsiveValue(context,
                                                defaultValue: 40.0,
                                                valueWhen: const [
                                                  Condition.smallerThan(
                                                      name: TABLET, value: 8.0)
                                                ]).value ??
                                            40.0,
                                        8.0),
                                    child:
                                        const AuthenticationSectionOverview()),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
            drawer: drawer(),
          );
  }
}
