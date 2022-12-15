import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/profile_model.dart';
import '../../screens/private/profile_screen.dart';
import '../../services/localization_service.dart';

class ProfileDrawerLinkComponent extends StatelessWidget {
  final ProfileModel? profile;
  const ProfileDrawerLinkComponent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: Row(children: [
        Text(
            LocalizationService.of(context)?.translate('profile_link_label') ??
                '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          icon: Icon(FontAwesomeIcons.circleChevronRight,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(profile: profile),
              ),
            );
          },
        ),
      ]),
    );
  }
}
