import 'package:flutter/material.dart';
import 'package:ipresenceapp/screens/company/company_home.dart';
import 'package:ipresenceapp/screens/company/company_profile.dart';

String? _TAG = "Ipresence CompanyTabs";

class CompanyTabs extends StatefulWidget {
  const CompanyTabs({super.key});

  @override
  State<CompanyTabs> createState() => _CompanyTabsState();
}

class _CompanyTabsState extends State<CompanyTabs> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CompanyHome(),
    CompanyProfile(),
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
            icon: Icon(Icons.person),
            label: 'Profile',
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
