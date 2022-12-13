// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/forms/update_password_form_component.dart';
import 'package:starter/components/icons/go_back_icon_component.dart';
import 'package:starter/components/links/go_back_link_component.dart';

import '../../models/profile.dart';
import '../../components/loaders/loader_spinner_component.dart';
import '../../services/localization_service.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final ProfileModel? profile;
  const UpdatePasswordScreen({Key? key, this.profile}) : super(key: key);

  final bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoaderSpinnerComponent()
        : Scaffold(
            appBar: AppBar(
              leading: const GoBackIconComponent(),
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: SizedBox(
                    width: ResponsiveValue(context,
                        defaultValue: 450.0,
                        valueWhen: const [
                          Condition.largerThan(name: MOBILE, value: 450.0),
                          Condition.smallerThan(
                              name: TABLET, value: double.infinity)
                        ]).value,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            UpdatePasswordFormComponent(profile: profile)
                          ],
                        ),
                        const SizedBox(height: 10),
                        GoBackLinkComponent(
                            removeState: false,
                            label: LocalizationService.of(context)?.translate(
                                    'go_back_home_profile_link_label') ??
                                ''),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
