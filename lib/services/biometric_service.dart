import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService extends ChangeNotifier {
  final LocalAuthentication localAuthentication = LocalAuthentication();

  final String key = "biometrics";
  late bool _biometrics;

  bool get biometrics => _biometrics;

  Future checkBiometrics() async {
    late bool canCheckBiometrics;

    try {
      canCheckBiometrics = await localAuthentication.canCheckBiometrics;
      final isDeviceSupported = await localAuthentication.isDeviceSupported();
      if (canCheckBiometrics == true && isDeviceSupported == true) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await localAuthentication.authenticate(
          localizedReason: 'OS determines best authentication method',
          options: const AuthenticationOptions(
            stickyAuth: true,
          ));
      if (authenticated == true) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  BiometricService() {
    _biometrics = false;
    loadFromPrefs();
  }

  toggleBiometrics() {
    _biometrics = !_biometrics;
    saveToPrefs();
  }

  loadFromPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _biometrics = pref.getBool(key) ?? true;
    if (kDebugMode) {
      print('Biometrics loaded from storage. Biometrics is: $_biometrics');
    }
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, _biometrics);
    if (kDebugMode) {
      print('Biometrics saved to storage. Biometrics is: $_biometrics');
    }
    notifyListeners();
  }
}
