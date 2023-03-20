import 'package:flutter/cupertino.dart';
import 'package:ipresenceapp/main.dart';
import 'package:ipresenceapp/models/UserLoginResponse.dart';

String _TAG = "I=P Company UserLoginResponseProvider";

class UserLoginResponseProvider extends ChangeNotifier {
  setUserLoginResponse(UserLoginResponse? userLoginResponse) async {
    kUserLoginResponse = userLoginResponse;
    notifyListeners();
    await kAppPreference.setUserLoginResponse(kUserLoginResponse);
  }

  // UserLoginResponse? getUserLoginResponse() {
  //   kUserLoginResponse =
  //       kAppPreference.getUserLoginResponse() as UserLoginResponse?;
  //   return kUserLoginResponse;
  // }

  void clear() {
    kUserLoginResponse = null;
    notifyListeners();
  }
}
