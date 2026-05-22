import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBootstrapper {
  static Future<SharedPreferences> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }
}
