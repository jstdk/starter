import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../utils/loading.dart';
import 'sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final supabase = Supabase.instance.client;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? email;
  String? password;
  bool obscureText = true;

  Future<void> signInUsingEmailAndPassword(email, password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      setState(() => {loading = false, error = 'Invalid email or password'});
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0.0,
              centerTitle: true,
              title:
                  const Text('Sign-In', style: TextStyle(color: Colors.white)),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Text('Welcome',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5.0),
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
                      TextFormField(
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
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
                            setState(() => password = val);
                          }),
                      const SizedBox(height: 20.0),
                      Text(error ?? '',
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 40.0),
                      GestureDetector(
                          child: const Text("I forgot my password"),
                          onTap: () {
                            showMaterialModalBottomSheet(
                                expand: false,
                                context: context,
                                builder: (context) => const SizedBox(
                                    height: 300, child: ForgotPassword()));
                          }),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Sign-In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              signInUsingEmailAndPassword(email, password);
                            } else {
                              setState(() {
                                loading = false;
                                error = 'Something went wrong.';
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      GestureDetector(
                        child: const Text("Sign-up using email"),
                        onTap: () {
                          Get.to(const SignUpScreen());
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          //   (kIsWeb && Platform.isIOS)
                          //       ? const Spacer()
                          //       : Container(),
                          //   IconButton(
                          //       icon:
                          //           const FaIcon(FontAwesomeIcons.facebookSquare),
                          //       onPressed: () {
                          //         setState(() => loading = true);
                          //         UserService()
                          //             .signInWithFacebook()
                          //             .then((result) {});
                          //       }),
                          //   const Spacer(),
                          //   IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.google),
                          //       onPressed: () {
                          //         setState(() => loading = true);
                          //         UserService()
                          //             .signInWithGoogle()
                          //             .then((result) {});
                          //       }),
                          //   (Platform.isIOS) ? const Spacer() : Container(),
                          //   (kIsWeb || Platform.isIOS)
                          //       ? IconButton(
                          //           icon: const FaIcon(FontAwesomeIcons.apple),
                          //           onPressed: () {
                          //             setState(() => loading = true);
                          //             UserService()
                          //                 .signInWithApple()
                          //                 .then((result) {});
                          //           })
                          //       : Container(),
                          //   (kIsWeb && Platform.isIOS)
                          //       ? const Spacer()
                          //       : Container(),
                        ],
                      ),
                    ],
                  )),
            ),
          );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
        ? const Loading()
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
                                Get.back();
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
