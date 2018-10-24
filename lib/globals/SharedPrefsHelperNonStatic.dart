//import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

//import 'global.dart';
// enum EnumPrefKey {serverAddress}
class SharedPrefsHelper {
  SharedPreferences preferences;

  Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<String> getString(String key, {String defaultValue}) async {
    if (preferences == null) {
      await init();
    }
    String val = preferences.getString(key);
    if (val == null && defaultValue != null) {
      await setString(key, defaultValue);
      return defaultValue;
    } else {
      return val;
    }
  }

  Future<bool> setString(String key, value) async {
    if (preferences == null) preferences = await init();
    try {
      preferences.setString(key, value);
      return true;
    } catch (error) {
      return false;
    }
  }
}
