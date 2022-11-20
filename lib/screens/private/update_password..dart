import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile.dart';
import '../../utils/loading.dart';
import '../root.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final ProfileModel? profile;
  const UpdatePasswordScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;

  String? error;
  String? passwordCurrent;
  String? passwordNew;
  String? passwordNewAgain;
  bool obscureText = true;

  Future updatePassword(passwordCurrent, passwordNew) async {
    // try {
    //   if (kDebugMode) {
    //     print('Trying to update profile');
    //   }
    //   print(avatarPathLocal!);
    //   final avatarFile = File(avatarPathLocal!);
    //   final String path = await supabase.storage.from('avatars').upload(
    //         'public/$id.jpg',
    //         avatarFile,
    //         fileOptions: const FileOptions(
    //             contentType: 'image/jpeg', cacheControl: '3600', upsert: true),
    //       );
    //   final data = await supabase.from('profiles').update(
    //       {'full_name': fullName, 'avatar': '$id.jpg'}).match({'id': id});
    // } catch (e) {
    //   setState(() => {loading = false, error = 'Something went wrong'});
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  passwordForm() {
    return Form(
        key: formKeyForm,
        child: Column(
          children: <Widget>[
            kIsWeb
                ? const Text('Current Password',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))
                : Container(),
            const SizedBox(height: 40.0),
            TextFormField(
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: "Current Password",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: "New Password",
                  labelStyle: const TextStyle(
                    fontSize: 15,
                  ), //label style
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(FontAwesomeIcons.unlockKeyhole),
                  ),
                  suffixIcon: InkWell(
                    onTap: _toggle,
                    child: Icon(
                      obscureText
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20.0,
                    ),
                  ),
                ),
                textAlign: TextAlign.left,
                autofocus: true,
                validator: (String? value) {
                  return (value != null && value.length < 2)
                      ? 'Please provide a valid password.'
                      : null;
                },
                onChanged: (val) {
                  setState(() => passwordCurrent = val);
                }),
            const SizedBox(height: 20.0),
            TextFormField(
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: "New Password",
                  labelStyle: const TextStyle(
                    fontSize: 15,
                  ), //label style
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(FontAwesomeIcons.unlockKeyhole),
                  ),
                  suffixIcon: InkWell(
                    onTap: _toggle,
                    child: Icon(
                      obscureText
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20.0,
                    ),
                  ),
                ),
                textAlign: TextAlign.left,
                autofocus: true,
                validator: (String? value) {
                  return (value != null && value.length < 2)
                      ? 'Please provide a valid password.'
                      : null;
                },
                onChanged: (val) {
                  setState(() => passwordNew = val);
                }),
            const SizedBox(height: 20.0),
            TextFormField(
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: "New Password again",
                  labelStyle: const TextStyle(
                    fontSize: 15,
                  ), //label style
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(FontAwesomeIcons.unlockKeyhole),
                  ),
                  suffixIcon: InkWell(
                    onTap: _toggle,
                    child: Icon(
                      obscureText
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20.0,
                    ),
                  ),
                ),
                textAlign: TextAlign.left,
                autofocus: true,
                validator: (String? value) {
                  return (value != passwordNewAgain)
                      ? 'Your passwords must be the same'
                      : null;
                },
                onChanged: (val) {
                  setState(() => passwordNewAgain = val);
                }),
            Text(error ?? '', style: const TextStyle(color: Colors.red)),
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
                    "Update Password",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (formKeyForm.currentState!.validate()) {
                    setState(() => loading = true);
                    final response =
                        await updatePassword(widget.profile?.id, passwordNew);
                    if (response == null) {
                      setState(() => loading = false);
                      if (!mounted) return;
                      //signout
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
              title: const Text(!kIsWeb ? 'Update Password' : ''),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(30.0), child: passwordForm()),
            ),
          );
  }
}
