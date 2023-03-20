import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ipresenceapp/components/custom_constants.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/constants/app_sizes.dart';
import 'package:ipresenceapp/main.dart';
import 'package:http/http.dart' as http;

String? _TAG = "Ipresence Company Designation";

class Designation extends StatefulWidget {
  const Designation({super.key});

  @override
  State<Designation> createState() => _DesignationState();
}

class _DesignationState extends State<Designation> {
  var companyId = '';
  var companyEmial = '';
  var companyMobile = '';

  Map admData = {};
  var dataList;
  setData() async {
    admData = await getAdminData();
  }

  @override
  void initState() {
    setData();
    getCompanyData();
    final timer = Timer(Duration(milliseconds: 500), () {
      getDepartmentData();
      Designation();
    });
    super.initState();
  }

  void getCompanyData() async {
    await kAppPreference.getCompanyLoginResponse().then(
          (value) => {
            companyId = value?.companyId
            // companyEmial = value?.email,
            // companyMobile = value?.mobile,
          },
        );
  }

  TextEditingController designationController = TextEditingController();

  String selectDesignation = "select";
  final designationList = [];
  String departmentId = '';
  var designationData = [];

  Future<void> getDepartmentData() async {
    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/department/${companyId.toString()}"));
    final jsonString = jsonDecode(response.body);
    dataList = jsonString["data"];

    print("$_TAG ${dataList.toString()}");

    if (response.statusCode == 200) {
      for (int i = 0; i < dataList.length; i++) {
        setState(() {
          if (designationList.contains(dataList[i]["department"].toString()) ==
              false) designationList.add(dataList[i]["department"]);
        });
      }
    }
  }

  Future<void> Designation() async {
    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/designation/${companyId.toString()}"));
    final jsonString = jsonDecode(response.body);
    designationData = jsonString["data"];
    if (response.statusCode == 200) {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar("Add Designation"),
      body: Container(
        child: ListView.builder(
            itemCount: designationData.length,
            itemBuilder: (context, index) {
              if (designationData.length == 0) {
                return Container();
              }
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                        "${designationData[index]['department'].toString().toUpperCase()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 8,
                      ),
                      for (int i = 0;
                          i < designationData[index]['designationList'].length;
                          i++) ...[
                        Card(
                          elevation: 0,
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${i + 1}" +
                                      capitalize(
                                          "${designationData[index]['designationList'][i]["designation"]}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );

              //  Card(
              //   child: Container(
              //     padding: EdgeInsets.all(10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Container(
              //             margin: EdgeInsets.all(10),
              //             child:
              //                 Text("${designationData[index]['department']}")),
              //         for (int i = 0;
              //             i < designationData[index]['designationList'].length;
              //             i++) ...[
              //           Container(
              //             child: Column(
              //               children: [
              //                 Text(
              //                     "${designationData[index]['designationList'][i]["designation"]}"),
              //               ],
              //             ),
              //           ),
              //         ]
              //       ],
              //     ),
              //   ),
              // );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: false,
                content:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        child: Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text(selectDesignation),
                              items: designationList
                                  .map((it) => DropdownMenuItem(
                                        value: it,
                                        child: Text(it),
                                      ))
                                  .toList(),
                              onChanged: (it) {
                                setState(() {
                                  selectDesignation = it.toString();
                                  for (int i = 0; i < dataList.length; i++) {
                                    if (selectDesignation ==
                                        dataList[i]["department"]) {
                                      departmentId = dataList[i]["_id"];
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: CustomTextField(
                          controller: designationController,
                          prefixIcon: Icon(Icons.design_services),
                          hintText: 'designation',
                          obsecureText: false,
                        ),
                      ),
                    ],
                  );
                }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final response = await http.post(
                          Uri.parse("http://139.59.69.40:3536/api/designation"),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(<String, dynamic>{
                            "company_id": companyId.toString(),
                            "designation": designationController.text,
                            "department_id": departmentId
                          }));
                      if (response.statusCode == 200) {}
                      Designation();
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
