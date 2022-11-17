import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
  String? passwordCurrent;
  String? passwordNew;

  XFile? avatarFile = null;
  String? avatarPath = null;

  Future updateProfile(id, fullName, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      final data = await supabase.from('profiles').update(
          {'full_name': fullName, 'avatar': '$id.png'}).match({'id': id});
      final avatarFile = File('path/to/file');

      final String path = await supabase.storage.from('avatars').upload(
            'public/$id.png',
            File(avatarPath!),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      print(path);
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future getAvatar() async {
    // Pick an image
    //final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // Capture a photo
    setState(() => {loading = true});

    avatarFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() => {loading = false, avatarPath = avatarFile!.path});
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('My profile'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: ResponsiveRowColumn(
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.center,
                rowPadding: const EdgeInsets.all(50),
                columnPadding: const EdgeInsets.all(50),
                children: [
                  ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: ResponsiveVisibility(
                        hiddenWhen: const [Condition.smallerThan(name: TABLET)],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('SomeProfileStuff'),
                            SizedBox(
                              width: 300,
                            )
                          ],
                        ),
                      )),
                  ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                              key: formKeyForm,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 40.0),
                                  const Text('My Profile',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 40.0),
                                  GestureDetector(
                                    onTap: () async => {await getAvatar()},
                                    child: SizedBox(
                                        height: 120.0,
                                        width: 120.0,
                                        child: avatarPath != null
                                            ? CircleAvatar(
                                                backgroundImage: FileImage(
                                                    File(avatarPath!)),
                                              )
                                            : const CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    'https://lh3.googleusercontent.com/a-/AAuE7mChgTiAe-N8ibcM3fB_qvGdl2vQ9jvjYv0iOOjB=s96-c'),
                                              )),
                                  ),
                                  const SizedBox(height: 40.0),
                                  TextFormField(
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                            fontSize: 15,
                                          ), //label style
                                          prefixIcon:
                                              Icon(FontAwesomeIcons.envelope),
                                          hintText: "email"),
                                      textAlign: TextAlign.left,
                                      initialValue: widget.profile!.email,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? 'Please provide a valid email.'
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      }),
                                  const SizedBox(height: 20),
                                  Text(error ?? '',
                                      style:
                                          const TextStyle(color: Colors.red)),
                                  TextFormField(
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          labelText: "Name",
                                          labelStyle: TextStyle(
                                            fontSize: 15,
                                          ), //label style
                                          prefixIcon:
                                              Icon(FontAwesomeIcons.person),
                                          hintText: "Full name"),
                                      textAlign: TextAlign.left,
                                      initialValue: widget.profile?.fullName,
                                      autofocus: true,
                                      validator: (String? value) {
                                        //print(value.length);
                                        return (value != null &&
                                                value.length < 2)
                                            ? 'Please provide a valid name.'
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => fullName = val);
                                      }),
                                  const SizedBox(height: 20.0),
                                  Text(error ?? '',
                                      style:
                                          const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 20.0),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      child: const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          "Update profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onPressed: () async {
                                        email = widget.profile?.email ?? email;
                                        fullName = widget.profile?.fullName ??
                                            fullName;
                                        //passwordNew = widget.profile?.password ?? password;

                                        if (formKeyForm.currentState!
                                            .validate()) {
                                          setState(() => loading = true);
                                          final response = await updateProfile(
                                              widget.profile?.id,
                                              fullName,
                                              email);
                                          print(response);
                                          if (response == null) {
                                            setState(() => loading = false);
                                            if (!mounted) return;
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Root()),
                                                    (Route<dynamic> route) =>
                                                        false);
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
                              )),
                        ],
                      ))
                ],
              ),
            ));
  }
}
