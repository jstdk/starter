import 'dart:typed_data';

import 'package:flutter/material.dart';

class FormService extends ChangeNotifier {
  static String? email;
  static String? fullName;
  static Uint8List? avatar;
  static String? password;
  static String? newPassword;
  static String? newPasswordAgain;
  static Uint8List? avatarBytes;

  late bool _signup;
  late bool _reset;
  late bool _obscureText;

  bool get signup => _signup;
  bool get reset => _reset;
  bool get obscureText => _obscureText;

  FormService() {
    _signup = false;
    _reset = false;
    _obscureText = true;
  }

  toggleSignUp() {
    _signup = !_signup;
    notifyListeners();
  }

  toggleReset() {
    _reset = !_reset;
    notifyListeners();
  }

  toggleObscure() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
