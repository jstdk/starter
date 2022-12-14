import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/links/update_profile_link_component.dart';
import 'package:starter/components/loaders/loader_spinner_component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/links/update_password_link_component.dart';
import '../../components/sections/profile_overview_section.dart';
import '../../main.dart';
import '../../models/profile.dart';
import '../../services/localization_service.dart';
import '../../components/links/go_back_link_component.dart';

final supabase = Supabase.instance.client;

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  final ProfileModel? profile;
  ProfileScreen({
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
        ? const LoaderSpinnerComponent()
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
                                    builder: (context) => const StarterApp()),
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
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                ProfileOverviewSectionComponent(
                                    profile: profile, avatarBytes: avatarBytes),
                                const SizedBox(height: 30),
                                UpdateProfileLinkComponent(
                                    profile: profile, avatarBytes: avatarBytes),
                                const SizedBox(height: 10),
                                UpdatePasswordLinkComponent(
                                  profile: profile,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GoBackLinkComponent(
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
