import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ipresenceapp/components/custom_constants.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/constants/app_sizes.dart';
import 'package:ipresenceapp/main.dart';
import 'package:http/http.dart' as http;

String? _TAG = "Ipresence Company Employee";

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
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
      getEmployeData();
      // Designation();
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

  TextEditingController EmployeeCodeController = TextEditingController();
  TextEditingController NameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController MobileController = TextEditingController();

  String selectedDepartment = "select";
  String selectedDesignation = "select";
  final designationList = [];
  String departmentId = '';
  var designationData = [];
  var designationIdList = [];
  String designationId = '';
  var employeeDataList = [];

  Future<void> getDepartmentData() async {
    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/department/${companyId.toString()}"));
    final jsonString = jsonDecode(response.body);
    dataList = jsonString["data"];

    if (response.statusCode == 200) {
      for (int i = 0; i < dataList.length; i++) {
        setState(() {
          if (designationList.contains(dataList[i]["department"].toString()) ==
              false) designationList.add(dataList[i]["department"]);
        });
      }
    }
  }

  Future<void> getEmployeData() async {
    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/employee/${companyId.toString()}"));
    final jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        employeeDataList = jsonString["data"];
      });
    }
  }

  // Future<void> GetDesignation(String department_id) async {
  //   print("object");

  //   final response = await http.get(Uri.parse(
  //       "http://139.59.69.40:3536/api/designation-by-department/$department_id"));
  //   final jsonString = jsonDecode(response.body);
  //   final designationDataList = jsonString["data"];

  //   print("response.body");
  //   print(designationDataList);

  //   // final data = jsonString['data'];

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       designationData = [];
  //       for (int i = 0; i < designationDataList.length; i++) {
  //         if (designationData
  //                 .contains(designationDataList[i]["designation"].toString()) ==
  //             false) {
  //           designationData
  //               .add(designationDataList[i]["designation"].toString());
  //         }
  //       }
  //       print(designationData);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar("Add Employee"),
      body: Container(
        child: ListView.builder(
            itemCount: employeeDataList.length,
            itemBuilder: (context, index) {
              if (employeeDataList.length == 0) {
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
                        "${employeeDataList[index]['department'].toString().toUpperCase()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 8,
                      ),
                      for (int i = 0;
                          i < employeeDataList[index]['employeeList'].length;
                          i++) ...[
                        Card(
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1} " +
                                      capitalize(employeeDataList[index]
                                                  ['employeeList'][i]
                                              ["employee_name"]
                                          .toString()),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.phone),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${employeeDataList[index]['employeeList'][i]["employee_mobile"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.mail),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${employeeDataList[index]['employeeList'][i]["employee_email"]}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // scrollable: false,
                content:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          child: Container(
                            width: size.width,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(selectedDepartment),
                                items: designationList
                                    .map((it) => DropdownMenuItem(
                                          onTap: () {},
                                          value: it,
                                          child: Text(
                                            it,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (it) async {
                                  setState(() async {
                                    selectedDepartment = it.toString();
                                    for (int i = 0; i < dataList.length; i++) {
                                      if (selectedDepartment ==
                                          dataList[i]["department"]) {
                                        departmentId = dataList[i]["_id"];
                                        break;
                                      }
                                    }
                                    final response = await http.get(Uri.parse(
                                        "http://139.59.69.40:3536/api/designation-by-department/$departmentId"));
                                    final jsonString =
                                        jsonDecode(response.body);
                                    designationIdList = jsonString["data"];

                                    if (response.statusCode == 200) {
                                      setState(() {
                                        designationData = [];
                                        for (int i = 0;
                                            i < designationIdList.length;
                                            i++) {
                                          if (designationData.contains(
                                                  designationIdList[i]
                                                          ["designation"]
                                                      .toString()) ==
                                              false) {
                                            designationData.add(
                                                designationIdList[i]
                                                        ["designation"]
                                                    .toString());
                                          }
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: size.width,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(selectedDesignation),
                                items: designationData
                                    .map((it) => DropdownMenuItem(
                                          value: it,
                                          child: Text(it),
                                        ))
                                    .toList(),
                                onChanged: (it) {
                                  setState(() {
                                    selectedDesignation = it.toString();
                                    for (int i = 0;
                                        i < designationIdList.length;
                                        i++) {
                                      if (selectedDesignation ==
                                          designationIdList[i]["designation"]) {
                                        designationId =
                                            designationIdList[i]["_id"];
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
                            controller: EmployeeCodeController,
                            prefixIcon: Icon(Icons.design_services,
                                color: Colors.black54),
                            hintText: 'Employee code',
                            obsecureText: false,
                          ),
                        ),
                        Container(
                          child: CustomTextField(
                            controller: NameController,
                            prefixIcon: Icon(Icons.abc, color: Colors.black54),
                            hintText: 'Name',
                            obsecureText: false,
                          ),
                        ),
                        Container(
                          child: CustomTextField(
                            controller: EmailController,
                            prefixIcon:
                                Icon(Icons.email, color: Colors.black54),
                            hintText: 'Email',
                            obsecureText: false,
                          ),
                        ),
                        Container(
                          child: CustomTextField(
                            controller: MobileController,
                            prefixIcon: Icon(
                              Icons.mobile_screen_share,
                              color: Colors.black54,
                            ),
                            hintText: 'Mobile',
                            obsecureText: false,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final response = await http.post(
                                Uri.parse(
                                    "http://139.59.69.40:3536/api/register-employee"),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode(<String, dynamic>{
                                  "company_id": companyId.toString(),
                                  "department_id": departmentId,
                                  "designation_id": designationId,
                                  "employee_name": NameController.text,
                                  "employee_code": EmployeeCodeController.text,
                                  "employee_mobile": MobileController.text,
                                  "employee_email": EmailController.text
                                }));
                            if (response.statusCode == 200) {
                              getEmployeData();
                            }
                            // Designation();
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            color: primaryColor,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                                // InkWell(
                                //   onTap: () {
                                //     Navigator.of(context).pop();
                                //   },
                                //   child: Container(
                                //     margin: EdgeInsets.symmetric(
                                //         horizontal: 10, vertical: 10),
                                //     child: Text('Cancel'),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
                // actions: [],
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
