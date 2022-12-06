import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:email_validator/email_validator.dart';

import '../../models/profile.dart';
import '../../services/localization.dart';
import '../../services/user.dart';
import '../../components/go_back_button.dart';
import '../../components/loading.dart';
import '../root.dart';
import 'profile.dart';

final supabase = Supabase.instance.client;

class UpdateProfileScreen extends StatefulWidget {
  final ProfileModel? profile;
  final Uint8List? avatarBytes;
  const UpdateProfileScreen({Key? key, this.profile, this.avatarBytes})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
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
                fillColor: Colors.white,
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

  emailFormField() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
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
                  ''),
          textAlign: TextAlign.left,
          initialValue: widget.profile!.email,
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

  nameFormField() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              labelText:
                  LocalizationService.of(context)?.translate('name_label') ??
                      '',
              labelStyle: const TextStyle(
                fontSize: 15,
              ), //label style
              prefixIcon: const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Icon(FontAwesomeIcons.faceLaugh),
              ),
              hintText: "Full name"),
          textAlign: TextAlign.left,
          initialValue: widget.profile?.fullName,
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

  updateProfileFormButton() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            LocalizationService.of(context)
                    ?.translate('update_profile_button_label') ??
                '',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          email = email ?? widget.profile?.email;
          fullName = fullName ?? widget.profile?.fullName;
          avatar = base64Avatar ?? widget.profile?.avatar;
          if (formKey.currentState!.validate()) {
            setState(() => loading = true);
            final response = await UserService().updateProfileProcedure(
                widget.profile?.id, fullName, email, avatar);
            if (response == true) {
              ProfileModel? newProfile = await UserService()
                  .loadProfile(widget.profile?.id, widget.profile!.email);
              if (!mounted) return;
              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                content: Text(
                    LocalizationService.of(context)
                            ?.translate('update_profile_snackbar') ??
                        '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    )),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (EmailValidator.validate(newProfile!.email)) {
                if (!mounted) return;
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(profile: newProfile)),
                    (route) => false);
              } else {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Root()),
                    (route) => false);
              }
            } else {
              setState(() {
                loading = false;
                error = LocalizationService.of(context)
                        ?.translate('general_error_message') ??
                    '';
              });
            }
          } else {
            setState(() {
              loading = false;
              error = LocalizationService.of(context)
                      ?.translate('general_error_message') ??
                  '';
            });
          }
        },
      ),
    );
  }

  updateProfileForm(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                kIsWeb
                    ? Text(
                        LocalizationService.of(context)
                                ?.translate('update_profile_header') ??
                            '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold))
                    : Container(),
                const SizedBox(height: 20.0),
                avatarFormField(),
                const SizedBox(height: 50.0),
                emailFormField(),
                const SizedBox(height: 20),
                nameFormField(),
                error != '' ? const SizedBox(height: 20) : Container(),
                Text(error ?? '', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20.0),
                updateProfileFormButton()
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingSpinnerComponent()
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
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(!kIsWeb ? 'Update Profile' : ''),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: SizedBox(
                    width: ResponsiveValue(context,
                        defaultValue: 400.0,
                        valueWhen: const [
                          Condition.largerThan(name: MOBILE, value: 400.0),
                          Condition.smallerThan(
                              name: TABLET, value: double.infinity)
                        ]).value,
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [updateProfileForm(context)],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const GoBackButtonComponent(removeAllState: false),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
