import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/Utils/routers.dart';
import 'package:ipresenceapp/constants/app_urls.dart';
import 'package:ipresenceapp/main.dart';
import 'package:ipresenceapp/models/CompanyLoginResponse.dart';
import 'package:ipresenceapp/providers/CompanyLoginResponseProvider.dart';
import 'package:ipresenceapp/screens/company/company_tabs/company_tab_page.dart';

String _TAG = "I=P Company Authentication";

class CompanyAuthentication {
  final CompanyLoginResponseProvider? companyLoginResponseProvider;

  ///Base Url
  final requestBaseUrl = AppUrl.baseUrl;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';

  CompanyAuthentication(this.companyLoginResponseProvider);

  //Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  void loginCompany({
    required String mobile,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;

    String url = "$requestBaseUrl/company-login";
    final body = {"mobile": mobile, "password": password};
    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: {"Content-Type": "Application/json"},
          body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        kCompanyLoginResponse =
            CompanyLoginResponse.fromJson(json.decode("${req.body}"));

        companyLoginResponseProvider
            ?.setCompanyLoginResponse(kCompanyLoginResponse);

        await kAppPreference.setCompanyLoginResponse(kCompanyLoginResponse);

        _isLoading = false;
        _resMessage = "Login successfull!";

        PageNavigator(ctx: context).nextPageOnly(page: const CompanyTabs());
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
