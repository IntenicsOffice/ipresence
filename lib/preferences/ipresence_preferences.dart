import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ipresenceapp/models/CompanyLoginResponse.dart';
import 'package:ipresenceapp/models/UserLoginResponse.dart';
import 'package:ipresenceapp/Utils/routers.dart';
import 'package:ipresenceapp/screens/user_credentials/user/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? _TAG = "I=P Ipresence Preferences";

class IpresencePreferences {
  static SharedPreferences? sharedPreferences;

  static const String KEY_USER_LOGIN_RESPONSE = "KEY_USER_LOGIN_RESPONSE";
  static const String KEY_COMPANY_LOGIN_RESPONSE = "KEY_COMPANY_LOGIN_RESPONSE";
  static const String KEY_IS_APP_FIRST_RUN = "KEY_IS_APP_FIRST_RUN";
  static const String KEY_EMPLOYEE_ATTENDANCE_RESPONSE =
      "KEY_EMPLOYEE_ATTENDANCE_RESPONSE";
  static const String KEY_WIFI_RANGE_TIME = "KEY_WIFI_RANGE_TIME";

//
  static const String KEY_ATTENDANCE_IN_TIME = "KEY_ATTENDANCE_IN_TIME";
  static const String KEY_ATTENDANCE_OUT_TIME = "KEY_ATTENDANCE_OUT_TIME";

  init() async {
    try {
      if (sharedPreferences == null) {
        sharedPreferences = await SharedPreferences.getInstance();
      }
    } catch (e) {}
  }

  //first time login
  setUserAppFirstRun(bool isAppFirstRun) {
    init();
    sharedPreferences?.setBool(KEY_IS_APP_FIRST_RUN, isAppFirstRun);
  }

  bool getUserAppFirstRun() {
    bool isAppFirstRun = false;
    init();
    sharedPreferences?.getBool(KEY_IS_APP_FIRST_RUN);
    return isAppFirstRun;
  }

  // Set User login Response
  setUserLoginResponse(UserLoginResponse? userLoginResponse) async {
    await init();
    // String temp = userLoginResponse?.toJson();
    // Map json = jsonDecode(userLoginResponse);

    // print("$_TAG ${userLoginResponse?.toJson()}");
    String user = jsonEncode(userLoginResponse?.toJson());
    await sharedPreferences?.setString(KEY_USER_LOGIN_RESPONSE, user);
  }

  // Set Company Login Response
  setCompanyLoginResponse(CompanyLoginResponse? companyLoginResponse) async {
    await init();
    // String temp = userLoginResponse?.toJson();
    // Map json = jsonDecode(userLoginResponse);
    String company = jsonEncode(companyLoginResponse?.toJson());
    await sharedPreferences?.setString(KEY_COMPANY_LOGIN_RESPONSE, company);
  }

  // Get User Login Response
  getUserLoginResponse() async {
    UserLoginResponse? userResponse;
    await init();

    String? user = sharedPreferences?.getString(KEY_USER_LOGIN_RESPONSE);
    userResponse =
        user != null ? UserLoginResponse.fromJson(jsonDecode(user)) : null;
    return userResponse;
  }

  // Get Company Login Response
  Future<CompanyLoginResponse?> getCompanyLoginResponse() async {
    CompanyLoginResponse? companyResponse;
    await init();

    String? company = sharedPreferences?.getString(KEY_COMPANY_LOGIN_RESPONSE);
    companyResponse = company != null
        ? CompanyLoginResponse.fromJson(jsonDecode(company))
        : null;
    return companyResponse;
  }

  // Set Employee Attendance
  setEmployeeAttendance(todayAttendance) async {
    await init();
    String attendance = jsonEncode(todayAttendance?.toJson());
    await sharedPreferences?.setString(
        KEY_EMPLOYEE_ATTENDANCE_RESPONSE, attendance);
  }

  setInTimeAttendance(String intime) async {
    await init();
    // String attendance = jsonEncode(intime);
    await sharedPreferences?.setString(KEY_ATTENDANCE_IN_TIME, intime);
  }

  setWifiRangeTime(String intime) async {
    await init();
    // String attendance = jsonEncode(intime?.toJson());
    await sharedPreferences?.setString(KEY_WIFI_RANGE_TIME, intime);
  }

  setOutTimeAttendance(String outtime) async {
    await init();
    // String attendance = jsonEncode(outtime?.toJson());
    await sharedPreferences?.setString(KEY_ATTENDANCE_OUT_TIME, outtime);
  }

  getInTimeAttendance() async {
    await init();
    String? todayAttendance =
        sharedPreferences?.getString(KEY_ATTENDANCE_IN_TIME);
    return todayAttendance;
  }

  getWifiRangeTime() async {
    await init();
    String? todayAttendance = sharedPreferences?.getString(KEY_WIFI_RANGE_TIME);
    return todayAttendance;
  }

  getOutTimeAttendance() async {
    await init();
    String? todayAttendance =
        sharedPreferences?.getString(KEY_ATTENDANCE_OUT_TIME);
    return todayAttendance;
  }

  removeOutTimeAttendance() async {
    await init();
    await sharedPreferences?.remove(KEY_ATTENDANCE_OUT_TIME);
  }

  removeInTimeAttendance() async {
    await init();
    await sharedPreferences?.remove(KEY_ATTENDANCE_IN_TIME);
  }
  //

  // Get Employee Attendance
  getEmployeeAttendance() async {
    await init();
    String? todayAttendance =
        sharedPreferences?.getString(KEY_EMPLOYEE_ATTENDANCE_RESPONSE);
    return todayAttendance;
  }

  // LogOut
  void logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    PageNavigator(ctx: context).nextPageOnly(page: const UserLogin());
  }
}
