import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/form_service.dart';

class PasswordEyeSlashIconWidget extends StatelessWidget {
  const PasswordEyeSlashIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: Consumer<FormService>(
          builder: (context, form, child) => IconButton(
              onPressed: () => form.toggleObscure(),
              icon: Icon(
                form.obscureText == true
                    ? (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.macOS)
                        ? CupertinoIcons.eye
                        : FontAwesomeIcons.eye
                    : (defaultTargetPlatform == TargetPlatform.iOS ||
                            defaultTargetPlatform == TargetPlatform.macOS)
                        ? CupertinoIcons.eye_slash
                        : FontAwesomeIcons.eyeSlash,
                size: 20.0,
              )),
        ));
  }
}
