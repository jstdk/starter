import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/utils/loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/profile.dart';
import '../../screens/root.dart';

// Initiate Supabase
final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  final ProfileModel? profile;
  const ProfileScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? email;
  String? fullName;
  String? passwordNew;
  String? passwordNewAgain;
  bool obscureText = true;

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
      final data = await supabase.from('profiles').update(
          {'full_name': fullName, 'avatar': '$id.jpg'}).match({'id': id});

      final String path = await supabase.storage.from('avatars').upload(
            '$id.jpg',
            File(avatarPathLocal!),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
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
    print(widget.profile?.avatar);

    if (widget.profile?.avatar != '') {
      avatarPathOnline = await supabase.storage
          .from('avatars')
          .createSignedUrl(widget.profile!.avatar, 60);

      print(avatarPathOnline);

      // final String avatarPathOnline =
      //     supabase.storage.from('avatars').getPublicUrl('$id.jpg');
      setState(() => {loading = false});
      return avatarPathOnline;
    } else {
      setState(() => {loading = false});
      return emptyAvatar;
    }
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
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
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(avatarPathLocal!)),
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
                    prefixIcon: Icon(FontAwesomeIcons.envelope),
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
                    prefixIcon: Icon(FontAwesomeIcons.faceLaugh),
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
              width: double.infinity,
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
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: const Text(!kIsWeb ? 'My profile' : ''),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
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
          );
  }
}
