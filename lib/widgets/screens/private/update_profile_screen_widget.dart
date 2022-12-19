import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/profile_model.dart';
import '../../../services/localization_service.dart';
import '../../forms/update_profile_form_widget.dart';
import '../../links/go_back_link_widget.dart';
import '../../loaders/loader_spinner_widget.dart';

final supabase = Supabase.instance.client;

class UpdateProfileScreenWidget extends StatelessWidget {
  final ProfileModel? profile;
  final Uint8List? avatarBytes;
  const UpdateProfileScreenWidget({Key? key, this.profile, this.avatarBytes})
      : super(key: key);

  final bool loading = false;

  @override
  Widget build(BuildContext context) {
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
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                            const SizedBox(height: 20),
                            UpdateProfileFormWidget(
                                profile: profile, avatarBytes: avatarBytes)
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
