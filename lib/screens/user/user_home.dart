import 'package:flutter/material.dart';

String? _TAG = "Ipresence User Home";

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [Text("user home")],
          ),
        ),
      ),
    );
  }
}
