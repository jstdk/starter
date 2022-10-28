import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Initiate Supabase
final supabase = Supabase.instance.client;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String? error;
  String? email;
  String? password;
  bool obscureText = true;
  String? signupSuccess;

  // Sign up user with email and password
  Future signUpUsingEmailAndPassword({email, password}) async {
    try {
      await supabase.auth.signUp(email: email, password: password);
      setState(() => {
            loading = false,
            error = '',
            signupSuccess =
                'Welcome! We sent you an email. Please confirm your email address to sign in'
          });
      Timer(const Duration(seconds: 5), () {
        Navigator.pop(context);
      });
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              elevation: 0.0,
              centerTitle: true,
              title:
                  const Text('Sign-Up', style: TextStyle(color: Colors.white)),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 40.0),
                      const Text('Sign up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          decoration: const InputDecoration(hintText: "Email"),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            //print(value.length);
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid email address.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => email = val);
                            //_showConfirmDialog(context);
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
                      Text(signupSuccess ?? ''),
                      SizedBox(height: signupSuccess != null ? 40.0 : 10.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Sign-Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              signUpUsingEmailAndPassword(
                                  email: email, password: password);
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
