import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future updateProfileProcedure(id, fullName, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      final data = await supabase
          .from('profiles')
          .update({'full_name': fullName}).match({'id': id});
      return data;
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(supabase.auth);

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
                                  const SizedBox(height: 20.0),
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
                                    width: 300,
                                    child: ElevatedButton(
                                      child: const Text(
                                        "Update profile",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        email = widget.profile?.email ?? email;
                                        fullName = widget.profile?.fullName ??
                                            fullName;
                                        //passwordNew = widget.profile?.password ?? password;

                                        if (formKeyForm.currentState!
                                            .validate()) {
                                          setState(() => loading = true);
                                          final response =
                                              await updateProfileProcedure(
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
