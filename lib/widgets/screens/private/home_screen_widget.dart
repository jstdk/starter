import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/services/message_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/message_model.dart';
import '../../../models/profile_model.dart';
import '../../../services/localization_service.dart';
import '../../../services/user_service.dart';
import '../../dropdowns/language_drawer_dropdown_widget.dart';
import '../../headers/private_end_drawer_header_widget.dart';
import '../../icons/private_drawer_icon_widget.dart';
import '../../icons/private_end_drawer_icon_widget.dart';
import '../../links/logo_header_link_widget.dart';
import '../../links/profile_drawer_link_widget.dart';
import '../../links/signout_drawer_link_widget.dart';
import '../../loaders/loader_spinner_widget.dart';
import '../../switchers/biometrics_drawer_switcher_widget.dart';
import '../../switchers/theme_drawer_switcher_widget.dart';

final supabase = Supabase.instance.client;

class HomeScreenWidget extends StatefulWidget {
  final ProfileModel? profile;
  const HomeScreenWidget({Key? key, required this.profile}) : super(key: key);

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late final Stream<List<MessageModel>> messages;
  Uint8List? avatarBytes;

  @override
  void initState() {
    messages = MessageService().loadMessages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  leftSection() {
    return ResponsiveRowColumnItem(
        child: ResponsiveVisibility(
      hiddenWhen: const [Condition.smallerThan(name: TABLET)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
            child: Row(
              children: [
                const Text('Open'),
                SizedBox(
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  middleSection(messages) {
    return ResponsiveRowColumnItem(
      rowFlex: 2,
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Card(
                // In many cases, the key isn't mandatory
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(message.content!),
                ));
          }),
    );
  }

  rightSection() {
    return ResponsiveRowColumnItem(
        rowFlex: 1,
        child: ResponsiveVisibility(
          hiddenWhen: const [Condition.smallerThan(name: TABLET)],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: const [
                    Text('YEAHHHHH'),
                  ],
                ),
              )),
              const SizedBox(
                width: 300,
              )
            ],
          ),
        ));
  }

  mainSection() {
    return SizedBox(
      width: double.infinity,
      height: double.maxFinite,
      child: StreamBuilder<List<MessageModel>>(
        stream: messages,
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderSpinnerWidget();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final messages = snapshot.data!;
              return ResponsiveRowColumn(
                  layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.start,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  rowPadding: const EdgeInsets.all(20),
                  columnPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  children: [
                    leftSection(),
                    middleSection(messages),
                    rightSection(),
                  ]);
            } else {
              return Text(LocalizationService.of(context)
                      ?.translate('no_data_message') ??
                  '');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  drawer() {
    return const Drawer(child: Text('Text'));
  }

  endDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const PrivateEndDrawerHeaderWidget(),
          const SizedBox(height: 20.0),
          ProfileDrawerLinkWidget(profile: widget.profile),
          const SizedBox(height: 5.0),
          const LanguageDrawerDropdownWidget(),
          const ThemeDrawerSwitcherWidget(),
          const BiometricsDrawerSwitcherWidget(),
          const SizedBox(height: 50),
          const SignOutDrawerLink()
        ],
      ),
    );
  }

  Future<ProfileModel> loadProfile() async {
    return await UserService().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            PrivateDrawerIconWidget(),
            LogoHeaderLinkWidget()
          ],
        ),
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: const [PrivateEndDrawerWidget()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [mainSection()],
        ),
      ),
      drawer: drawer(),
      endDrawer: endDrawer(),
    );
  }
}
