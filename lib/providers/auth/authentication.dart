import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/models/UserLoginResponse.dart';
import 'package:ipresenceapp/constants/app_urls.dart';
import 'package:ipresenceapp/main.dart';
import 'package:ipresenceapp/providers/UserLoginResponseProvider.dart.dart';
import 'package:ipresenceapp/screens/user/user_tabs/user_tab_page.dart';

import '../../Utils/routers.dart';

String _TAG = "I=P Authentication";

class Authentication {
  final UserLoginResponseProvider? userLoginResponseProvider;

  ///Base Url
  final requestBaseUrl = AppUrl.baseUrl;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';

  Authentication(this.userLoginResponseProvider);

  //Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  //Login
  void loginUser({
    required String empId,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;

    String url = "$requestBaseUrl/login-employee";
    final body = {"emp_id": empId, "password": password};
    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: {"Content-Type": "Application/json"},
          body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        kUserLoginResponse =
            UserLoginResponse.fromJson(json.decode("${req.body}"));

        userLoginResponseProvider?.setUserLoginResponse(kUserLoginResponse);

        await kAppPreference.setUserLoginResponse(kUserLoginResponse);

        _isLoading = false;
        _resMessage = "Login successfull!";

        PageNavigator(ctx: context).nextPageOnly(page: const UserTabs());
        // Navigator.push(context!, MaterialPageRoute(builder: (context) {
        //   return UserTabPage();
        // }));
      } else {
        final res = json.decode(req.body);
        _resMessage = res['message'];
        _isLoading = false;
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available`";
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again`";

      print(":::: $e");
    }
  }

  void clear() {
    _resMessage = "";
    // _isLoading = false;
  }
}
