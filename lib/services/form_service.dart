import 'dart:typed_data';

import 'package:flutter/material.dart';

class FormService extends ChangeNotifier {
  static String? email;
  static String? fullName;
  static Uint8List? avatar;
  static String? password;
  static String? newPassword;
  static String? newPasswordAgain;

  late bool _signup;
  late bool _reset;

  bool get signup => _signup;
  bool get reset => _reset;

  FormService() {
    _signup = false;
    _reset = false;
  }

  toggleSignUp() {
    _signup = !_signup;
    notifyListeners();
  }

  toggleReset() {
    _reset = !_reset;
    notifyListeners();
  }
}
