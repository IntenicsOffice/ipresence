import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/main.dart';
import '../../constants/app_sizes.dart';

String? _TAG = "Ipresence CompanyHome";

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  var empCount = 0;
  var dataList;
  var employeeDataList = [];
  var companyId = '';

  @override
  void initState() {
    Timer(const Duration(seconds: 10), () {
      getCompanyData();
      getEmployeData();
      getEmployeCount();
    });
    super.initState();
  }

  void getCompanyData() async {
    await kAppPreference.getCompanyLoginResponse().then((value) => {
          companyId = value?.companyId,
        });
  }

  Future<void> getEmployeData() async {
    final response = await http.get(Uri.parse(
        "http://192.168.0.103:3536/api/employee/${companyId.toString()}}"));
    final jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        employeeDataList = jsonString["data"];
      });
    }
  }

  Future<void> getEmployeCount() async {
    final response = await http.get(
      Uri.parse(
        "http://139.59.69.40:3536/api/employee-count/${companyId.toString()}}",
      ),
    );
    final jsonString = jsonDecode(response.body);

    empCount = jsonString['data']["total_employee"];
    if (response.statusCode == 200) {
      setState(() {
        empCount = jsonString['data']["total_employee"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(children: [
        Container(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              SizedBox(
                  height: size.height * 0.25,
                  width: size.width,
                  child: Image.asset(
                    "assets/images/banner_04.png",
                    fit: BoxFit.fitWidth,
                  )),
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  const Text(
                    "Intenics",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  const Text("Total Employees of the company",
                      style: TextStyle(color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.group,
                        color: Colors.white,
                      ),
                      Text(
                        "  $empCount",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "430",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Text(
                                "Present",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "40",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: const [
                              Text(
                                "Absent",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "25",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              ListView.builder(
                  itemCount: employeeDataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (employeeDataList.isEmpty) {
                      return const CircularProgressIndicator();
                    }
                    return Card(
                      elevation: 3,
                      // margin:
                      //     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employeeDataList[index]['department']
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                for (int i = 0;
                                    i <
                                        employeeDataList[index]['employeeList']
                                            .length;
                                    i++) ...[
                                  Card(
                                    elevation: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black54)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      child: Text(
                                        employeeDataList[index]["employeeList"]
                                                [i]['employee_code']
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        )
      ]),
    );
  }
}
