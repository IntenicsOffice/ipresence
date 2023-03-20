import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSizes {
  static const double pagePadding = 16.0;
}

getAdminData() async {
  final prefs = await SharedPreferences.getInstance();
  final str = prefs.getString("admin_user_data");
  Map m = jsonDecode(str!);
  return m;
}

String capitalize(String value) {
  var result = value[0].toUpperCase();
  bool cap = true;
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " " && cap == true) {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
      cap = false;
    }
  }
  return result;
}

const Color primaryColor = Color(0xff166534);
