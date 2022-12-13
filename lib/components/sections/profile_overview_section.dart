import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/headers/profile_header_component.dart';

import '../../models/profile.dart';

class ProfileOverviewSectionComponent extends StatelessWidget {
  final ProfileModel? profile;
  final Uint8List? avatarBytes;
  const ProfileOverviewSectionComponent(
      {super.key, this.profile, this.avatarBytes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 30.0),
        const ProfileHeaderComponent(),
        const SizedBox(height: 40.0),
        SizedBox(
            height: ResponsiveValue(context,
                defaultValue: 200.0,
                valueWhen: const [
                  Condition.smallerThan(name: TABLET, value: 175.0)
                ]).value,
            width: ResponsiveValue(context,
                defaultValue: 200.0,
                valueWhen: const [
                  Condition.smallerThan(name: TABLET, value: 175.0)
                ]).value,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(avatarBytes!))),
        const SizedBox(height: 50.0),
        Text(
          profile!.fullName,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(profile!.email),
      ],
    );
  }
}
