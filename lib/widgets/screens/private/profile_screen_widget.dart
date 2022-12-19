import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../../models/profile_model.dart';
import '../../../services/localization_service.dart';
import '../../links/go_back_link_widget.dart';
import '../../links/update_password_link_widget.dart';
import '../../links/update_profile_link_widget.dart';
import '../../loaders/loader_spinner_widget.dart';
import '../../sections/profile_overview_section_widget.dart';

final supabase = Supabase.instance.client;

// ignore: must_be_immutable
class ProfileScreenWidget extends StatelessWidget {
  final ProfileModel? profile;
  ProfileScreenWidget({
    super.key,
    required this.profile,
  });

  final formKeyForm = GlobalKey<FormState>();
  final bool loading = false;
  XFile? avatarFile;
  Uint8List? avatarBytes;

  @override
  Widget build(BuildContext context) {
    avatarBytes = base64Decode(profile!.avatar);

    return loading
        ? const LoaderSpinnerWidget()
        : Scaffold(
            appBar: AppBar(
                leading: ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [Condition.smallerThan(name: TABLET)],
                  child: Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const App()),
                                (route) => false);
                      },
                    );
                  }),
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: SizedBox(
                    width: ResponsiveValue(context,
                        defaultValue: 450.0,
                        valueWhen: const [
                          Condition.largerThan(name: MOBILE, value: 450.0),
                          Condition.smallerThan(
                              name: MOBILE, value: double.infinity)
                        ]).value,
                    child: Column(
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.onSurface,
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                ProfileOverviewSectionWidget(
                                    profile: profile, avatarBytes: avatarBytes),
                                const SizedBox(height: 30),
                                UpdateProfileLinkWidget(
                                    profile: profile, avatarBytes: avatarBytes),
                                const SizedBox(height: 10),
                                UpdatePasswordLinkWidget(
                                  profile: profile,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GoBackLinkWidget(
                            removeState: true,
                            label: LocalizationService.of(context)
                                    ?.translate('go_back_home_link_label') ??
                                ''),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
