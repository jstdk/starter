import 'dart:async';
import 'dart:io' as uio;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile.dart';
import '../../utils/loading.dart';
import '../root.dart';

class UpdateProfileScreen extends StatefulWidget {
  final ProfileModel? profile;
  const UpdateProfileScreen({Key? key, this.profile}) : super(key: key);

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

  late final fileImage;
  XFile? avatarFile;
  String? avatarPathLocal;
  String? avatarPathOnline;
  String emptyAvatar =
      "https://dfymjnonymnyxvsobdmk.supabase.co/storage/v1/object/public/avatars/emptyAvatar.jpg";

  Future updateProfile(id, fullName, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }

      dynamic file = uio.File(avatarPathLocal!);
      fileImage = FileImage(file);
      //final avatarFile = uio.File(avatarPathLocal!);
      final String path = await supabase.storage.from('avatars').upload(
            'public/$id.jpg',
            file,
            fileOptions: const FileOptions(
                contentType: 'image/jpeg', cacheControl: '3600', upsert: true),
          );
      final data = await supabase.from('profiles').update(
          {'full_name': fullName, 'avatar': '$id.jpg'}).match({'id': id});
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future createAvatarToUpload() async {
    // Pick an image
    //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // Capture a photo
    setState(() => {loading = true});

    avatarFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() => {loading = false, avatarPathLocal = avatarFile!.path});
  }

  Future prepareAvatarOnLoad() async {
    if (widget.profile?.avatar != '') {
      avatarPathOnline = await supabase.storage
          .from('avatars/public')
          .createSignedUrl(widget.profile!.avatar, 60);

      return avatarPathOnline;
    } else {
      return emptyAvatar;
    }
  }

  profileForm(avatarPath) {
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
            const SizedBox(height: 40.0),
            SizedBox(
              height: 120.0,
              width: 120.0,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  avatarPathLocal != null
                      ? kIsWeb
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(avatarPathLocal!))
                          :
                          //Container()
                          CircleAvatar(
                              backgroundImage: fileImage,
                            )
                      // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
                      : avatarPath != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(avatarPath),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(emptyAvatar),
                            ),
                  Positioned(
                      bottom: 0,
                      right: -25,
                      child: RawMaterialButton(
                        onPressed: () async => {await createAvatarToUpload()},
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
            // TextFormField(
            //     obscureText: obscureText,
            //     decoration: InputDecoration(
            //       hintText: "Password",
            //       border: const OutlineInputBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(5))),
            //       labelText: "New Password",
            //       labelStyle: const TextStyle(
            //         fontSize: 15,
            //       ), //label style
            //       prefixIcon: const Padding(
            //         padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            //         child: Icon(FontAwesomeIcons.unlockKeyhole),
            //       ),
            //       suffixIcon: InkWell(
            //         onTap: _toggle,
            //         child: Icon(
            //           obscureText
            //               ? FontAwesomeIcons.eye
            //               : FontAwesomeIcons.eyeSlash,
            //           size: 20.0,
            //         ),
            //       ),
            //     ),
            //     textAlign: TextAlign.left,
            //     autofocus: true,
            //     validator: (String? value) {
            //       return (value != null && value.length < 2)
            //           ? 'Please provide a valid password.'
            //           : null;
            //     },
            //     onChanged: (val) {
            //       setState(() => passwordNew = val);
            //     }),
            // const SizedBox(height: 20.0),
            // TextFormField(
            //     obscureText: obscureText,
            //     decoration: InputDecoration(
            //       hintText: "Password",
            //       border: const OutlineInputBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(5))),
            //       labelText: "New Password again",
            //       labelStyle: const TextStyle(
            //         fontSize: 15,
            //       ), //label style
            //       prefixIcon: const Padding(
            //         padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            //         child: Icon(FontAwesomeIcons.unlockKeyhole),
            //       ),
            //       suffixIcon: InkWell(
            //         onTap: _toggle,
            //         child: Icon(
            //           obscureText
            //               ? FontAwesomeIcons.eye
            //               : FontAwesomeIcons.eyeSlash,
            //           size: 20.0,
            //         ),
            //       ),
            //     ),
            //     textAlign: TextAlign.left,
            //     autofocus: true,
            //     validator: (String? value) {
            //       return (value != passwordNewAgain)
            //           ? 'Your passwords must be the same'
            //           : null;
            //     },
            //     onChanged: (val) {
            //       setState(() => passwordNewAgain = val);
            //     }),
            // Text(error ?? '', style: const TextStyle(color: Colors.red)),
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
                      setState(() => loading = false);
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
                child: Center(
                  child: FutureBuilder(
                    builder: (ctx, snapshot) {
                      // Checking if future is resolved or not
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object
                          final avatarPathFuture = snapshot.data as String;
                          return profileForm(avatarPathFuture);
                        }
                      }
                      return const Center(
                        child: LoadingUtil(),
                      );
                    },
                    future: prepareAvatarOnLoad(),
                  ),
                ),
              ),
            ),
          );
  }
}
