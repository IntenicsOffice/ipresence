import 'package:flutter/material.dart';
import 'package:ipresenceapp/main.dart';

String? _TAG = "Ipresence User Account";

class UserAccount extends StatelessWidget {
  const UserAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        kAppPreference.logOut(context);
      },
      child: const Text(
        "Logout",
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}
