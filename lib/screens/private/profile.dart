import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile.dart';

// Initiate Supabase
final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  final Profile? profile;
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
  bool signup = false;

  Future<void> updateProfile(email) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
    } catch (e) {
      setState(() => {loading = false, error = 'Invalid email or password'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text('My profile'),
            ),
            body: ResponsiveRowColumn(
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
                                const SizedBox(height: 20.0),
                                TextFormField(
                                    decoration: const InputDecoration(
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
                                const SizedBox(height: 20.0),
                                Text(error ?? '',
                                    style: const TextStyle(color: Colors.red)),
                                const SizedBox(height: 40.0),
                                TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Full name"),
                                    textAlign: TextAlign.left,
                                    initialValue: widget.profile!.fullName,
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
                                Text(error ?? '',
                                    style: const TextStyle(color: Colors.red)),
                                GestureDetector(
                                    child: const Text("Reset my password"),
                                    onTap: () {
                                      showMaterialModalBottomSheet(
                                          expand: false,
                                          context: context,
                                          builder: (context) => const SizedBox(
                                              height: 300,
                                              child: ResetPassword()));
                                    }),
                                const SizedBox(height: 20.0),
                                SizedBox(
                                  width: 300,
                                  child: ElevatedButton(
                                    child: const Text(
                                      "Update profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      if (formKeyForm.currentState!
                                          .validate()) {
                                        setState(() => loading = true);
                                        updateProfile(email);
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
            ));
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';
  String? email;
  String? resetPasswordRequestSuccess;

  Future<void> resetPassword(email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: _formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      const Text('Reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 10),
                      Text(resetPasswordRequestSuccess ?? ''),
                      const SizedBox(height: 10),
                      TextFormField(
                          decoration: const InputDecoration(hintText: "Email"),
                          textAlign: TextAlign.left,
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
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Reset password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              resetPassword(email);
                              setState(() => loading = false);
                              setState(() => resetPasswordRequestSuccess =
                                  'Reset email sent, please check your email');
                              Timer(const Duration(seconds: 3), () {
                                Navigator.pop(context);
                              });
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
            ),
          );
  }
}
