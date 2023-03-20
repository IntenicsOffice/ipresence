// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:ipresenceapp/main.dart';
import 'package:ipresenceapp/screens/company/company_tabs/company_tab_page.dart';
import 'package:ipresenceapp/screens/user/user_tabs/user_tab_page.dart';
import 'package:ipresence/screens/user_credentials/user/user_login.dart';
import 'utils/routers.dart';

String? _TAG = "Ipresence Splash Screen";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 5), () async {
      if (await kAppPreference
          .getUserLoginResponse()
          .then((value) => value?.accessToken != null)) {
        PageNavigator(ctx: context).nextPageOnly(page: const UserTabs());
      } else if (await kAppPreference
          .getCompanyLoginResponse()
          .then((value) => value?.accessToken != null)) {
        PageNavigator(ctx: context).nextPageOnly(page: const CompanyTabs());
      } else {
        PageNavigator(ctx: context).nextPageOnly(page: const UserLogin());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/i_presence_logo.png',
            height: 120,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Loading...",
                style: TextStyle(
                    color: Colors.grey[800], fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 10,
              ),
              const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: Colors.green,
                  strokeWidth: 2,
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
