import 'package:flutter/cupertino.dart';
import 'package:ipresenceapp/main.dart';
import 'package:ipresenceapp/models/CompanyLoginResponse.dart';

String _TAG = "I=P Company CompanyLoginResponseProvider";

class CompanyLoginResponseProvider extends ChangeNotifier {
  setCompanyLoginResponse(CompanyLoginResponse? companyLoginResponse) async {
    kCompanyLoginResponse = companyLoginResponse;
    notifyListeners();
    await kAppPreference.setCompanyLoginResponse(kCompanyLoginResponse);
  }

  // CompanyLoginResponse? getCompanyLoginResponse() {
  //   kCompanyLoginResponse =
  //       kAppPreference.getCompanyLoginResponse() as CompanyLoginResponse?;
  //   return kCompanyLoginResponse;
  // }

  void clear() {
    kCompanyLoginResponse = null;
    notifyListeners();
  }
}
