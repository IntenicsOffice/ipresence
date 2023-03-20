import 'package:flutter/material.dart';
import 'package:ipresenceapp/screens/user/user_account.dart';
import 'package:ipresenceapp/screens/user/user_face_detection.dart';
import 'package:ipresenceapp/screens/user/user_home.dart';
import 'package:ipresenceapp/screens/user/user_qrcode.dart';

String? _TAG = "Ipresence User Tabs";

class UserTabs extends StatefulWidget {
  const UserTabs({super.key});

  @override
  State<UserTabs> createState() => _UserTabsState();
}

class _UserTabsState extends State<UserTabs> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    UserHome(),
    UserQRCode(),
    UserFaceDetection(),
    UserAccount()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Face Detection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey[800],
        onTap: _onItemTapped,
        selectedFontSize: 12,
      ),
    );
  }
}
