import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/localization_service.dart';
import '../../services/user_service.dart';

class SignOutDrawerLink extends StatelessWidget {
  const SignOutDrawerLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: Row(children: [
        Text(
            LocalizationService.of(context)?.translate('sign_out_link_label') ??
                '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          icon: Icon(FontAwesomeIcons.circleChevronRight,
              color: Theme.of(context).colorScheme.onBackground),
          onPressed: () async {
            final signOutSnackbar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_out_snackbar_label') ??
                      '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            );
            ScaffoldMessenger.of(context).showSnackBar(signOutSnackbar);
            await UserService().signOut();
          },
        ),
      ]),
    );
  }
}
