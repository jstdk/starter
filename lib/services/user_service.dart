import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';

final supabase = Supabase.instance.client;

class UserService extends ChangeNotifier {
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
      if (kDebugMode) {
        print(e);
      }
      return false;
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
      if (kDebugMode) {
        print(e);
      }
      return false;
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future updateEmail(id, email) async {
    try {
      if (kDebugMode) {
        print('Trying to update email');
      }
      return await supabase.auth.updateUser(
        UserAttributes(
          email: email,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future updateProfile(id, fullName, avatar) async {
    try {
      if (kDebugMode) {
        print('Trying to update profile');
      }
      return await supabase
          .from('profiles')
          .update({'full_name': fullName, 'avatar': avatar}).match({'id': id});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future updateProfileProcedure(fullName, email, avatar) async {
    try {
      if (kDebugMode) {
        print('Trying to update email and profile procedure');
      }
      UserResponse emailUpdate =
          await updateEmail(supabase.auth.currentUser!.id, email);
      final profileUpdate =
          await updateProfile(supabase.auth.currentUser!.id, fullName, avatar);
      if (EmailValidator.validate(emailUpdate.user!.email!) &&
          profileUpdate == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future updatePassword(passwordNew) async {
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
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future loadProfile() async {
    return ProfileModel.fromMap(
        map: await supabase
            .from('profiles')
            .select()
            .eq('id', supabase.auth.currentUser!.id)
            .single(),
        emailFromAuth: supabase.auth.currentUser!.email!);
  }
}
