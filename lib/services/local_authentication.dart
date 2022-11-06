import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthenticationService extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  final String key = "biometrics";
  late bool _biometrics;

  bool get biometrics => _biometrics;

  Future checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics == true) {
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
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method');
      //useErrorDialogs: true,
      //stickyAuth: true);
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

  LocalAuthenticationService() {
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
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, _biometrics);
    notifyListeners();
  }
}
