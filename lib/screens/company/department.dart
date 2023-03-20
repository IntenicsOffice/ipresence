import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/components/custom_constants.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/constants/app_sizes.dart';
import 'package:ipresenceapp/main.dart';

String? _TAG = "Ipresence Company Department";

class Department extends StatefulWidget {
  const Department({super.key});

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  final TextEditingController _departmentName = TextEditingController();

  var companyId = '';
  var companyEmial = '';
  var companyMobile = '';

  bool isloading = false;

  @override
  void initState() {
    getCompanyData();
    Timer(const Duration(seconds: 3), () {
      getDepartmentData();
    });
    setState(() {
      isloading = true;
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

  final departmentList = [];

  Future<void> getDepartmentData() async {
    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/department/${companyId.toString()}"));
    final jsonString = jsonDecode(response.body);
    final dataList = jsonString["data"];

    if (response.statusCode == 200) {
      for (int i = 0; i < dataList.length; i++) {
        setState(() {
          if (departmentList.contains(dataList[i]["department"].toString()) ==
              false) departmentList.add(dataList[i]["department"]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Department"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView.builder(
            itemCount: departmentList.length,
            itemBuilder: (context, index) {
              if (departmentList.isEmpty) {
                return const CircularProgressIndicator();
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${index + 1}.  ${capitalize("${departmentList[index]}")}"),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 0.5,
                      thickness: 0.3,
                      // indent: 20,
                      // endIndent: 0,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: CustomTextField(
                  hintText: "Department name",
                  prefixIcon: const Icon(
                    Icons.local_fire_department,
                    color: Colors.black87,
                  ),
                  controller: _departmentName,
                  obsecureText: false,
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      final response = await http.post(
                          Uri.parse("http://139.59.69.40:3536/api/department"),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(<String, dynamic>{
                            "company_id": companyId.toString(),
                            
                            "department": _departmentName.text,
                          }));

                      if (response.statusCode == 200) {
                        getDepartmentData();
                        Navigator.of(context).pop();
                      }
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
