import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ipresenceapp/components/custom_constants.dart';
import 'package:ipresenceapp/main.dart';
import 'package:ipresenceapp/screens/company/department.dart';
import 'package:ipresenceapp/screens/company/designation.dart';
import 'package:ipresenceapp/screens/company/employee.dart';

String? _TAG = "Ipresence Company Profile";

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  bool isloading = false;

  var companyName = '';
  var companyEmial = '';
  var companyMobile = '';

  @override
  void initState() {
    getCompanyData();
    Timer(const Duration(milliseconds: 5), () {
      setState(() {
        isloading = true;
      });
    });
    super.initState();
  }

  void getCompanyData() async {
    await kAppPreference.getCompanyLoginResponse().then((value) => {
          companyName = value?.companyName,
          companyEmial = value?.email,
          companyMobile = value?.mobile,
        });
  }

  @override
  Widget build(BuildContext context) {
    return isloading == false
        ? const CircularProgressIndicator()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        color: Colors.green[800],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companyName.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.mail,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      customText(companyEmial)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      customText(companyMobile)
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Employee();
                          }));
                        },
                        child: Card(
                          elevation: 0,
                          child: CustomRow(
                            ic: Icons.person_add,
                            data: 'Add Employee',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Department();
                          }));
                        },
                        child: Card(
                          elevation: 0,
                          child: CustomRow(
                            ic: Icons.home_repair_service,
                            data: 'Add Department',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Designation();
                              },
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          child: CustomRow(
                            ic: Icons.chair_alt_sharp,
                            data: 'Add Designation',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          kAppPreference.logOut(context);
                        },
                        child: Card(
                          elevation: 0,
                          child: CustomRow(
                            ic: Icons.logout,
                            data: 'LogOut',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
