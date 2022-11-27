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
import '../../utils/loading.dart';
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
  String? error = '';
  String? email;
  String? fullName;
  String? avatar;

  dynamic tempFile;
  XFile? avatarFile;

  dynamic avatarAsBytes;
  String? base64Avatar;
  Uint8List? avatarBytes;
  final ImagePicker _picker = ImagePicker();

  Future updateEmail(id, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update email');
      }
      return await supabase.auth.updateUser(
        UserAttributes(
          email: email,
        ),
      );
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future updateProfile(id, fullName, avatar) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      return await supabase
          .from('profiles')
          .update({'full_name': fullName, 'avatar': avatar}).match({'id': id});
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future updateProfileProcedure(id, fullName, email, avatar) async {
    try {
      if (kDebugMode) {
        print('Trying to update email and profile procedure');
      }
      UserResponse emailUpdate = await updateEmail(id, email);
      final profileUpdate = await updateProfile(id, fullName, avatar);
      if (EmailValidator.validate(emailUpdate.user!.email!) &&
          profileUpdate == null) {
        return null;
      } else {
        setState(() => {loading = false, error = 'Something went wrong'});
        return false;
      }
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

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

  Future loadUpdatedProfile() async {
    return ProfileModel.fromMap(
        map: await supabase
            .from('profiles')
            .select()
            .eq('id', widget.profile?.id)
            .single(),
        emailFromAuth: widget.profile!.email);
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
              : widget.avatarBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(widget.avatarBytes!))
                  : SizedBox(
                      width: 50,
                      child: Image.asset('assets/images/defaultAvatar.jpg'),
                    ),
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
                          title: const Center(
                              child: Text(kIsWeb
                                  ? 'Select an image'
                                  : 'Make or select an image')),
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
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              labelText: "Email",
              labelStyle: TextStyle(
                fontSize: 15,
              ), //label style
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Icon(FontAwesomeIcons.envelope),
              ),
              hintText: "email"),
          textAlign: TextAlign.left,
          initialValue: widget.profile!.email,
          autofocus: true,
          validator: (String? value) {
            return !EmailValidator.validate(value!)
                ? 'Please provide a valid email.'
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
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              labelText: "Name",
              labelStyle: TextStyle(
                fontSize: 15,
              ), //label style
              prefixIcon: Padding(
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
                ? 'Please provide a valid name.'
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
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Update profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          email = email ?? widget.profile?.email;
          fullName = fullName ?? widget.profile?.fullName;
          avatar = base64Avatar ?? widget.profile?.avatar;
          if (formKey.currentState!.validate()) {
            setState(() => loading = true);
            final response = await updateProfileProcedure(
                widget.profile?.id, fullName, email, avatar);
            if (response == null) {
              ProfileModel? newProfile = await loadUpdatedProfile();
              if (!mounted) return;
              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                content: const Text('Your profile has been updated',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
            }
          } else {
            setState(() {
              loading = false;
              error = 'Something went wrong.';
            });
          }
        },
      ),
    );
  }

  profileForm(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                kIsWeb
                    ? const Text('My Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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

  goBackButton() {
    return ResponsiveVisibility(
      visible: false,
      visibleWhen: const [Condition.largerThan(name: MOBILE)],
      child: Builder(builder: (context) {
        return TextButton(
          child: const Text(
            "Go back",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingUtil()
        : Scaffold(
            appBar: AppBar(
              leading: ResponsiveVisibility(
                visible: false,
                visibleWhen: const [Condition.smallerThan(name: DESKTOP)],
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
                              children: [profileForm(context)],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        goBackButton()
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
