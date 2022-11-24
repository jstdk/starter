import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/loading.dart';

// Initiate Supabase
final supabase = Supabase.instance.client;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? email;
  String? password;
  String? signupSuccess;
  String? resetPasswordRequestSuccess;
  bool obscureText = true;
  bool signup = false;
  bool reset = false;

  Future<void> signInUsingEmailAndPassword(email, password) async {
    try {
      if (kDebugMode) {
        print('Trying to sign in');
      }
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      setState(() => {loading = false, error = 'Invalid email or password'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Sign up user with email and password
  Future signUpUsingEmailAndPassword({email, password}) async {
    try {
      if (kDebugMode) {
        print('Trying to sign up');
      }
      await supabase.auth.signUp(email: email, password: password);
      setState(() => {
            loading = false,
            error = '',
            signupSuccess =
                'Welcome! We sent you an email. Please confirm your email address to sign in'
          });
    } catch (e) {
      setState(() => {loading = false, error = 'Oops. Something went wrong'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> signInUsingGoogle() async {
    try {
      if (kDebugMode) {
        print('Trying to sign in');
      }
      await supabase.auth.signInWithOAuth(
        Provider.google,
        redirectTo: kIsWeb ? null : 'io.supabase.starter://login-callback/',
      );
    } catch (e) {
      setState(() => {loading = false, error = 'Invalid email or password'});
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> resetPassword(email) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
      );
      setState(() {
        loading = false;
        resetPasswordRequestSuccess =
            'Reset email sent, please check your email';
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          reset = false;
        });
      });
    } catch (e) {
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

  signInUpForm() {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10.0),
            Text('Get Started',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: ResponsiveValue(context,
                        defaultValue: 30.0,
                        valueWhen: const [
                          Condition.smallerThan(name: DESKTOP, value: 20.0),
                          Condition.largerThan(name: TABLET, value: 30.0)
                        ]).value,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 40.0),
            SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 300.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 300.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent),
                onPressed: () async {
                  signInUsingGoogle();
                  final snackBarSignIn = SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    content: const Text('Signin you in with Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBarSignIn);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Sign-In using Google",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(children: const <Widget>[
              Expanded(child: Divider()),
              Text("OR"),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 30.0),
            TextFormField(
                decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ), //label style
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Icon(FontAwesomeIcons.envelope),
                    )),
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
            const SizedBox(height: 15.0),
            TextFormField(
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: "Password",
                  labelStyle: const TextStyle(
                    fontSize: 15,
                  ), //label style
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(FontAwesomeIcons.unlockKeyhole),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: InkWell(
                      onTap: _toggle,
                      child: Icon(
                        obscureText
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 20.0,
                      ),
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
            error != '' ? const SizedBox(height: 20.0) : Container(),
            Text(error ?? '', style: const TextStyle(color: Colors.red)),
            GestureDetector(
                child: const Text("I forgot my password",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() => reset = true);
                }),
            const SizedBox(height: 20.0),
            SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 300.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 300.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: signup == false
                  ? ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Sign-In using email",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          signInUsingEmailAndPassword(email, password);
                          final snackBarSignIn = SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            content: const Text(
                                'Welcome back. You have been signed in',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarSignIn);
                        } else {
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    )
                  : ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Sign-Up using email",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          signUpUsingEmailAndPassword(
                              email: email, password: password);
                          final snackBarSignUp = SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            content:
                                const Text('Welcome. You have been signed up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarSignUp);
                        } else {
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    ),
            ),
            const SizedBox(height: 30.0),
            Row(children: const <Widget>[
              Expanded(child: Divider()),
              Text("OR"),
              Expanded(child: Divider()),
            ]),
            const SizedBox(height: 30.0),
            SizedBox(
              width: ResponsiveValue(context,
                  defaultValue: 300.0,
                  valueWhen: const [
                    Condition.largerThan(name: MOBILE, value: 300.0),
                    Condition.smallerThan(name: TABLET, value: double.infinity)
                  ]).value,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    formKey.currentState!.reset();
                    error = '';
                    signup = !signup;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    signup == false
                        ? "Sign-up using email"
                        : "Sign-in using email",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  resetPasswordForm() {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            const Text('Reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            Text(resetPasswordRequestSuccess ?? ''),
            const SizedBox(height: 10),
            TextFormField(
                decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ), //label style
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Icon(FontAwesomeIcons.envelope),
                    )),
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
                    "Reset password",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    resetPassword(email);
                  } else {
                    setState(() {
                      loading = false;
                      error = 'Something went wrong.';
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 30.0),
            GestureDetector(
                child: const Text("Go back",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() => reset = false);
                }),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingUtil()
        : Scaffold(
            appBar: AppBar(),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const ResponsiveVisibility(
                      visible: false,
                      visibleWhen: [Condition.largerThan(name: MOBILE)],
                      child: SizedBox(height: 50)),
                  ResponsiveRowColumn(
                    layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                    rowPadding: const EdgeInsets.all(80),
                    columnPadding: const EdgeInsets.all(20),
                    children: [
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: ResponsiveVisibility(
                            hiddenWhen: const [
                              Condition.smallerThan(name: TABLET)
                            ],
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 10, 100, 10),
                                  child: Row(
                                    children: [
                                      Text('YEAH!'),
                                      Spacer(),
                                      Text('YEAH!'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Column(
                            children: [
                              Card(
                                color: Colors.grey[800],
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: reset == false
                                      ? signInUpForm()
                                      : resetPasswordForm(),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ));
  }
}
