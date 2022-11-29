import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/localization.dart';
import '../../utils/loading.dart';

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

  Future signInUsingEmailAndPassword(email, password) async {
    try {
      if (kDebugMode) {
        print('Trying to sign in');
      }
      AuthResponse result = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (EmailValidator.validate(result.user!.email!)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      setState(() => {
            loading = false,
            error = LocalizationService.of(context)
                    ?.translate('authentication_error_message') ??
                ''
          });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future signUpUsingEmailAndPassword({email, password}) async {
    try {
      if (kDebugMode) {
        print('Trying to sign up');
      }
      AuthResponse result =
          await supabase.auth.signUp(email: email, password: password);
      if (EmailValidator.validate(result.user!.email!)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      setState(() => {
            loading = false,
            error = LocalizationService.of(context)
                    ?.translate('general_error_message') ??
                ''
          });
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
      setState(() => {
            loading = false,
            error = LocalizationService.of(context)
                    ?.translate('authentication_error_message') ??
                ''
          });
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
        reset = false;
        loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        error = LocalizationService.of(context)
                ?.translate('general_error_message') ??
            '';
        loading = false;
      });
    }
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  emailFormField() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          decoration: InputDecoration(
              hintText: LocalizationService.of(context)
                      ?.translate('email_hinttext') ??
                  '',
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              labelText:
                  LocalizationService.of(context)?.translate('email_label') ??
                      '',
              labelStyle: const TextStyle(
                fontSize: 15,
              ), //label style
              prefixIcon: const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Icon(FontAwesomeIcons.envelope),
              )),
          autofocus: true,
          validator: (String? value) {
            return !EmailValidator.validate(value!)
                ? 'Please provide a valid email.'
                : null;
          },
          onChanged: (val) {
            setState(() => email = val);
          }),
    );
  }

  passwordFormField() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: LocalizationService.of(context)
                    ?.translate('password_hinttext') ??
                '',
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            labelText:
                LocalizationService.of(context)?.translate('password_label') ??
                    '',
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
    );
  }

  signInUpFormButton() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: signup == false
          ? ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_in_button_label') ??
                      '',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  setState(() => loading = true);
                  bool success =
                      await signInUsingEmailAndPassword(email, password);
                  if (success == true) {
                    if (!mounted) return;
                    final signInSnackbar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                          LocalizationService.of(context)
                                  ?.translate('sign_in_snackbar') ??
                              '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(signInSnackbar);
                  }
                } else {
                  setState(() {
                    loading = false;
                  });
                }
              },
            )
          : ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  LocalizationService.of(context)
                          ?.translate('sign_up_button_label') ??
                      '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  setState(() => loading = true);
                  bool success = await signUpUsingEmailAndPassword(
                      email: email, password: password);
                  if (success == true) {
                    if (!mounted) return;
                    setState(() => loading = false);
                    final signUpSnackbar = SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      content: Text(
                          LocalizationService.of(context)
                                  ?.translate('sign_up_snackbar') ??
                              '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(signUpSnackbar);
                    setState(() => signup = false);
                  }
                } else {
                  setState(() {
                    loading = false;
                  });
                }
              },
            ),
    );
  }

  signInUpSwitcher() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
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
            error = null;
            signup = !signup;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            signup == false
                ? LocalizationService.of(context)
                        ?.translate('sign_up_switcher_link_label') ??
                    ''
                : LocalizationService.of(context)
                        ?.translate('sign_up_switcher_link_label') ??
                    '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  signInUpForm() {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Text(
                LocalizationService.of(context)
                        ?.translate('sign_in_up_card_header') ??
                    '',
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    LocalizationService.of(context)
                            ?.translate('sign_in_google_button_label') ??
                        '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(children: <Widget>[
              const Expanded(child: Divider()),
              Text(LocalizationService.of(context)?.translate('or') ?? ''),
              const Expanded(child: Divider()),
            ]),
            const SizedBox(height: 30.0),
            emailFormField(),
            const SizedBox(height: 15.0),
            passwordFormField(),
            error != null ? const SizedBox(height: 20) : Container(),
            Text(error ?? '', style: const TextStyle(color: Colors.red)),
            error != null ? const SizedBox(height: 20) : Container(),
            signInUpFormButton(),
            const SizedBox(height: 20.0),
            GestureDetector(
                child: Text(
                    LocalizationService.of(context)
                            ?.translate('reset_password_link_label') ??
                        '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() => reset = true);
                }),
            const SizedBox(height: 30.0),
            Row(children: <Widget>[
              const Expanded(child: Divider()),
              Text(LocalizationService.of(context)?.translate('or') ?? ''),
              const Expanded(child: Divider()),
            ]),
            const SizedBox(height: 30.0),
            signInUpSwitcher(),
          ],
        ));
  }

  resetPasswordFormButton() {
    return SizedBox(
      width: ResponsiveValue(context, defaultValue: 300.0, valueWhen: const [
        Condition.largerThan(name: MOBILE, value: 300.0),
        Condition.smallerThan(name: TABLET, value: double.infinity)
      ]).value,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            LocalizationService.of(context)
                    ?.translate('reset_password_button_label') ??
                '',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            setState(() => loading = true);
            await resetPassword(email);
            if (!mounted) return;
            final resetPasswordSnackbar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              content: Text(
                  LocalizationService.of(context)
                          ?.translate('reset_password_snackbar') ??
                      '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            );
            ScaffoldMessenger.of(context).showSnackBar(resetPasswordSnackbar);
          } else {
            setState(() {
              loading = false;
            });
          }
        },
      ),
    );
  }

  resetPasswordForm(context) {
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            const Text('Reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            emailFormField(),
            const SizedBox(height: 20.0),
            resetPasswordFormButton(),
            const SizedBox(height: 30.0),
            GestureDetector(
                child: Text(
                    LocalizationService.of(context)
                            ?.translate('go_back_link') ??
                        '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() => {reset = false, signup = false});
                }),
          ],
        ));
  }

  jumbotron() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 100, 10),
      child: Column(
        children: [
          SizedBox(
            width: ResponsiveValue(context,
                defaultValue: 500.0,
                valueWhen: const [
                  Condition.smallerThan(name: TABLET, value: 250.0)
                ]).value,
            child: Text(
                LocalizationService.of(context)?.translate('main_tagline') ??
                    '',
                style:
                    TextStyle(
                        fontSize: ResponsiveValue(context,
                            defaultValue: 60.0,
                            valueWhen: const [
                              Condition.smallerThan(name: TABLET, value: 30.0)
                            ]).value,
                        fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: ResponsiveValue(context,
                defaultValue: 500.0,
                valueWhen: const [
                  Condition.smallerThan(name: TABLET, value: 250.0)
                ]).value,
            child: Text(
                LocalizationService.of(context)?.translate('sub_tagline') ?? '',
                style: TextStyle(
                    fontSize: ResponsiveValue(context,
                        defaultValue: 20.0,
                        valueWhen: const [
                          Condition.smallerThan(name: TABLET, value: 10.0)
                        ]).value,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingUtil()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                child: Text(LocalizationService.of(context)
                        ?.translate('brand_header') ??
                    ''),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [Condition.smallerThan(name: TABLET)],
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.bars,
                          size: 20.0,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      );
                    },
                  ),
                ),
                ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [Condition.largerThan(name: MOBILE)],
                  child: Builder(builder: (context) {
                    return TextButton(
                      child: Text(
                        LocalizationService.of(context)
                                ?.translate('about_us_header') ??
                            '',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: () {},
                    );
                  }),
                ),
                ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [Condition.largerThan(name: MOBILE)],
                  child: Builder(builder: (context) {
                    return TextButton(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          LocalizationService.of(context)
                                  ?.translate('pricing_header') ??
                              '',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ),
                      onPressed: () {},
                    );
                  }),
                ),
                ResponsiveVisibility(
                  visible: false,
                  visibleWhen: const [Condition.largerThan(name: MOBILE)],
                  child: Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: TextButton(
                        child: Text(
                          LocalizationService.of(context)
                                  ?.translate('contact_header') ??
                              '',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    );
                  }),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const ResponsiveVisibility(
                      visible: false,
                      visibleWhen: [Condition.largerThan(name: TABLET)],
                      child: SizedBox(height: 20)),
                  ResponsiveRowColumn(
                    layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? ResponsiveRowColumnType.COLUMN
                        : ResponsiveRowColumnType.ROW,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: ResponsiveVisibility(
                            hiddenWhen: const [
                              Condition.smallerThan(name: TABLET)
                            ],
                            child: Column(
                              children: [
                                jumbotron(),
                              ],
                            ),
                          )),
                      ResponsiveRowColumnItem(
                          rowFlex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                width: ResponsiveValue(context,
                                    defaultValue: 450.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                          name: MOBILE, value: 400.0),
                                      Condition.smallerThan(
                                          name: TABLET, value: double.infinity)
                                    ]).value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.grey[800],
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 40.0, 15.0, 40.0),
                                      child: reset == false
                                          ? signInUpForm()
                                          : resetPasswordForm(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
            endDrawer: const Drawer(child: Text('Text')),
          );
  }
}
