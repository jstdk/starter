// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../models/profile_model.dart';
import '../../../services/localization_service.dart';
import '../../forms/update_password_form_widget.dart';
import '../../icons/go_back_icon_widget.dart';
import '../../links/go_back_link_widget.dart';
import '../../loaders/loader_spinner_widget.dart';

class UpdatePasswordScreenWidget extends StatelessWidget {
  final ProfileModel? profile;
  const UpdatePasswordScreenWidget({Key? key, this.profile}) : super(key: key);

  final bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoaderSpinnerWidget()
        : Scaffold(
            appBar: AppBar(
              leading: const GoBackIconWidget(),
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerTitle: true,
            ),
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
                              name: TABLET, value: double.infinity)
                        ]).value,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            UpdatePasswordFormWidget(profile: profile)
                          ],
                        ),
                        const SizedBox(height: 20),
                        GoBackLinkWidget(
                            removeState: false,
                            label: LocalizationService.of(context)
                                    ?.translate('go_back_profile_link_label') ??
                                ''),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
