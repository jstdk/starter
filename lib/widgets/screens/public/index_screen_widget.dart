import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../drop_downs/language_header_dropdown_widget.dart';
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
import '../../loaders/loader_spinner_widget.dart';
import '../../sections/authentication_section_widget.dart';
import '../../sections/jumbotron_index_section_widget.dart';

final supabase = Supabase.instance.client;

class IndexScreenWidget extends StatefulWidget {
  const IndexScreenWidget({Key? key}) : super(key: key);

  @override
  State<IndexScreenWidget> createState() => _IndexScreenWidgetState();
}

class _IndexScreenWidgetState extends State<IndexScreenWidget> {
  bool loading = false;

  drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PublicDrawerHeaderWidget(),
          const SizedBox(height: 20.0),
          const FeaturesDrawerLinkWidget(highlight: false),
          Divider(color: Theme.of(context).colorScheme.onBackground),
          const PricingDrawerLinkWidget(highlight: false),
          Divider(color: Theme.of(context).colorScheme.onBackground),
          const FaqDrawerLinkWidget(highlight: false),
          Divider(color: Theme.of(context).colorScheme.onBackground),
          const AboutDrawerLinkWidget(highlight: false)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoaderSpinnerWidget()
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
                PricingHeaderLinkWidget(highlight: false),
                AboutUsHeaderLinkWidget(highlight: false),
                FaqHeaderLinkWidget(highlight: false),
                LanguageHeaderDropdownWidget(),
                ThemeHeaderIconWidget(),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveRowColumn(
                      layout:
                          ResponsiveWrapper.of(context).isSmallerThan(TABLET)
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
                                  JumbotronIndexSectionWidget(),
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
                                            name: TABLET,
                                            value: double.infinity)
                                      ]).value,
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          8.0,
                                          30.0,
                                          ResponsiveValue(context,
                                                  defaultValue: 40.0,
                                                  valueWhen: const [
                                                    Condition.smallerThan(
                                                        name: TABLET,
                                                        value: 8.0)
                                                  ]).value ??
                                              40.0,
                                          8.0),
                                      child:
                                          const AuthenticationSectionOverviewWidget()),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            drawer: drawer(),
          );
  }
}
