//import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

//import 'global.dart';
// enum EnumPrefKey {serverAddress}
class SharedPrefsHelperStatic {
  static SharedPreferences preferences;

  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

 static  String getString(String key )   {
   
    return preferences.getString(key);
  }

 static Future<bool>   setString(String key, value)  async {
   
    return await preferences.setString(key, value);
    
  }
}
