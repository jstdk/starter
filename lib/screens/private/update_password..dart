// ignore: file_names
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:starter/utils/go_back.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile.dart';
import '../../utils/loading.dart';

final supabase = Supabase.instance.client;

class UpdatePasswordScreen extends StatefulWidget {
  final ProfileModel? profile;
  const UpdatePasswordScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  String? error = '';
  String? passwordNew;
  String? passwordNewAgain;
  bool obscureText = true;

  Future updatePassword(id, passwordNew) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      UserResponse result = await supabase.auth.updateUser(
        UserAttributes(
          password: passwordNew,
        ),
      );
      if (EmailValidator.validate(result.user!.email!)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      setState(() => {loading = false, error = 'Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  newPasswordFormField() {
    return SizedBox(
        width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
          Condition.largerThan(name: MOBILE, value: 300.0),
          Condition.smallerThan(name: TABLET, value: double.infinity)
        ]).value,
        child: TextFormField(
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
            }));
  }

  newPasswordAgainFormField() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
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
                obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                size: 20.0,
              ),
            ),
          ),
          textAlign: TextAlign.left,
          autofocus: true,
          validator: (String? value) {
            return (value != passwordNew)
                ? 'Your passwords are not the same'
                : null;
          },
          onChanged: (val) {
            setState(() => passwordNewAgain = val);
          }),
    );
  }

  updatePasswordFormButton() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: ElevatedButton(
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Update Password",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            setState(() => loading = true);
            final response =
                await updatePassword(widget.profile?.id, passwordNew);
            setState(() => loading = false);
            if (response != null) {
              if (!mounted) return;
              final snackBar = SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                content: const Text('Password has been updated',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    )),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
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

  updatePasswordForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                kIsWeb
                    ? const Text('Edit Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold))
                    : Container(),
                const SizedBox(height: 40.0),
                newPasswordFormField(),
                const SizedBox(height: 20.0),
                newPasswordAgainFormField(),
                error != '' ? const SizedBox(height: 20) : Container(),
                Text(error ?? '', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                updatePasswordFormButton(),
              ],
            )),
      ),
    );
  }

  // goBackButton() {
  //   return ResponsiveVisibility(
  //     visible: false,
  //     visibleWhen: const [Condition.largerThan(name: MOBILE)],
  //     child: Builder(builder: (context) {
  //       return TextButton(
  //         child: const Text(
  //           "Go back",
  //           style: TextStyle(fontSize: 15, color: Colors.white),
  //         ),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //       );
  //     }),
  //   );
  // }

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
              title: const Text(!kIsWeb ? 'Update Password' : ''),
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
                              children: [updatePasswordForm()],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GoBackButton()
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
