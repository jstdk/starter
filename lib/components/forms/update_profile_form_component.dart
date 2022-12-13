import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/components/buttons/update_profile_button_component.dart';
import 'package:starter/components/headers/profile_header_component.dart';

import '../../models/profile.dart';
import '../../screens/private/profile_screen.dart';
import '../../screens/root.dart';
import '../../services/localization_service.dart';
import '../../services/user_service.dart';

class UpdateProfileFormComponent extends StatefulWidget {
  final ProfileModel? profile;
  final Uint8List? avatarBytes;

  const UpdateProfileFormComponent(
      {super.key, required this.profile, this.avatarBytes});

  @override
  State<UpdateProfileFormComponent> createState() =>
      _UpdateProfileFormComponentState();
}

class _UpdateProfileFormComponentState
    extends State<UpdateProfileFormComponent> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loader = false;

  String? error;
  String? email;
  String? fullName;
  String? avatar;

  dynamic tempFile;
  XFile? avatarFile;

  dynamic avatarAsBytes;
  String? base64Avatar;
  Uint8List? avatarBytes;
  final ImagePicker _picker = ImagePicker();

  Future pickAvatar(camera) async {
    Navigator.pop(context);
    avatarFile = await _picker.pickImage(
        source: camera == true ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640);
    if (avatarFile != null) {
      setState(() => {loading = true});
    }
    avatarAsBytes = await avatarFile!.readAsBytes();
    base64Avatar = base64Encode(avatarAsBytes);
    setState(
        () => {loading = false, avatarBytes = base64Decode(base64Avatar!)});
  }

  avatarFormField() {
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          avatarBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(avatarBytes!))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(widget.avatarBytes!)),
          Positioned(
              bottom: -15,
              right: -15,
              child: RawMaterialButton(
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: SimpleDialog(
                          title: Center(
                              child: Text(kIsWeb
                                  ? LocalizationService.of(context)
                                          ?.translate('select_avatar_label') ??
                                      ''
                                  : LocalizationService.of(context)?.translate(
                                          'make_select_avatar_label') ??
                                      '')),
                          children: <Widget>[
                            Row(
                              children: [
                                const Spacer(),
                                kIsWeb
                                    ? Container()
                                    : IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.cameraRetro,
                                          size: 20.0,
                                        ),
                                        onPressed: () async {
                                          await pickAvatar(true);
                                        },
                                      ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.image,
                                    size: 20.0,
                                  ),
                                  onPressed: () async {
                                    await pickAvatar(false);
                                  },
                                ),
                                const Spacer()
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                },
                elevation: 2.0,
                fillColor: Theme.of(context).colorScheme.onBackground,
                padding: const EdgeInsets.all(8.0),
                shape: const CircleBorder(),
                child: Icon(
                  FontAwesomeIcons.camera,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),
        ],
      ),
    );
  }

  emailFormField(profile) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 450.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 450.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            labelText: LocalizationService.of(context)
                    ?.translate('email_input_label') ??
                '',
            labelStyle: const TextStyle(
              fontSize: 15,
            ), //label style
            prefixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(FontAwesomeIcons.envelope),
            ),
            hintText: LocalizationService.of(context)
                    ?.translate('email_input_hinttext') ??
                '',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 1.0,
              ),
            ),
          ),
          textAlign: TextAlign.left,
          initialValue: profile!.email,
          autofocus: true,
          validator: (String? value) {
            return !EmailValidator.validate(value!)
                ? LocalizationService.of(context)
                        ?.translate('invalid_email_message') ??
                    ''
                : null;
          },
          onChanged: (val) {
            setState(() => email = val);
          }),
    );
  }

  nameFormField(profile) {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 450.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 450.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            labelText:
                LocalizationService.of(context)?.translate('name_label') ?? '',
            labelStyle: const TextStyle(
              fontSize: 15,
            ), //label style
            prefixIcon: const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Icon(FontAwesomeIcons.faceLaugh),
            ),
            hintText: "Full name",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 1.0,
              ),
            ),
          ),
          textAlign: TextAlign.left,
          initialValue: profile?.fullName,
          autofocus: true,
          validator: (String? value) {
            //print(value.length);
            return (value != null && value.length < 2)
                ? LocalizationService.of(context)
                        ?.translate('invalid_name_message') ??
                    ''
                : null;
          },
          onChanged: (val) {
            setState(() => fullName = val);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const ProfileHeaderComponent(),
                const SizedBox(height: 30.0),
                avatarFormField(),
                const SizedBox(height: 50.0),
                emailFormField(widget.profile),
                const SizedBox(height: 20),
                nameFormField(widget.profile),
                error != null ? const SizedBox(height: 20) : Container(),
                Text(error ?? '', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10.0),
                UpdateProfileButtonComponent(formKey: formKey)
              ],
            )),
      ),
    );
  }
}
