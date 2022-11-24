import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/profile.dart';
import '../../utils/loading.dart';
import '../root.dart';

class UpdateProfileScreen extends StatefulWidget {
  final ProfileModel? profile;
  final Uint8List? avatarBytes;
  const UpdateProfileScreen({Key? key, this.profile, this.avatarBytes})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? email;
  String? fullName;
  String? passwordNew;
  String? passwordNewAgain;
  bool obscureText = true;

  // ignore: prefer_typing_uninitialized_variables
  late final localFileImage;
  dynamic tempFile;
  XFile? avatarFile;
  String? avatarPathLocal;
  String? avatarPathOnline;

  dynamic avatarAsBytes;
  String? base64Avatar;
  Uint8List? avatarBytes;

  Future updateProfile(id, fullName, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      return await supabase
          .from('profiles')
          .update({'avatar': base64Avatar}).match({'id': id});
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future pickAvatar(camera) async {
    setState(() => {loading = true});
    Navigator.pop(context);
    avatarFile = await _picker.pickImage(
        source: camera == true ? ImageSource.camera : ImageSource.gallery);
    avatarAsBytes = await avatarFile!.readAsBytes();
    base64Avatar = base64Encode(avatarAsBytes);
    setState(
        () => {loading = false, avatarBytes = base64Decode(base64Avatar!)});
  }

  profileForm(context) {
    return Form(
        key: formKeyForm,
        child: Column(
          children: <Widget>[
            kIsWeb
                ? const Text('My Profile',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))
                : Container(),
            const SizedBox(height: 20.0),
            SizedBox(
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
                              child: Image.asset(
                                  'assets/images/defaultAvatar.jpg'),
                            ),
                  Positioned(
                      bottom: -15,
                      right: -15,
                      child: RawMaterialButton(
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Expanded(
                                child: SimpleDialog(
                                  title: const Text('Create or pick an avatar'),
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.camera,
                                        size: 20.0,
                                      ),
                                      onPressed: () async {
                                        await pickAvatar(true);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.photoFilm,
                                        size: 20.0,
                                      ),
                                      onPressed: () async {
                                        await pickAvatar(false);
                                      },
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
            ),
            const SizedBox(height: 50.0),
            TextFormField(
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
                  //print(value.length);
                  return (value != null && value.length < 2)
                      ? 'Please provide a valid email.'
                      : null;
                },
                onChanged: (val) {
                  setState(() => email = val);
                }),
            const SizedBox(height: 20),
            TextFormField(
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
            const SizedBox(height: 20.0),
            SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 300.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 300.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Update profile",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  email = widget.profile?.email ?? email;
                  fullName = widget.profile?.fullName ?? fullName;
                  if (formKeyForm.currentState!.validate()) {
                    setState(() => loading = true);
                    final response = await updateProfile(
                        widget.profile?.id, fullName, email);
                    if (response == null) {
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const Root()),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    setState(() {
                      loading = false;
                      error = 'Something went wrong.';
                    });
                  }
                },
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingUtil()
        : Scaffold(
            appBar: AppBar(
              title: const Text(!kIsWeb ? 'My profile' : ''),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(child: profileForm(context))),
            ),
          );
  }
}
