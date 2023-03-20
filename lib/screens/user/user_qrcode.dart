import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? _TAG = "Ipresence User QR Code";

class UserQRCode extends StatefulWidget {
  const UserQRCode({super.key});

  @override
  State<UserQRCode> createState() => _UserQRCodeState();
}

class _UserQRCodeState extends State<UserQRCode> {
  var QRCodeData;
  var responsefromJson;
  Map resmap = {};
  var company_id;
  var user_id;

  var userId = '';
  var companyId = '';
  var userName = '';
  var userCode = '';
  var companyEmial = '';
  var companyMobile = '';

  bool isloading = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      getQRCodeData();
    });
    getUserData();
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        isloading = true;
      });
    });
    getData();
    super.initState();
  }

  void getUserData() async {
    await kAppPreference.getUserLoginResponse().then(
          (value) => {
            userId = value?.userId,
            companyId = value?.companyId,
            userName = value?.name
          },
        );
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      responsefromJson = prefs.get("user_data");
    });
    resmap = jsonDecode(responsefromJson);
    company_id = companyId.toString();
    user_id = userId.toString();
  }

  Future<void> getQRCodeData() async {
    final response = await http.get(Uri.parse(
        'http://139.59.69.40:3536/api/employee-qrcode/${companyId.toString()}/${userId.toString()}'));
    final jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          QRCodeData = jsonString["data"];
        });
      }
    }
  }

  convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }

  @override
  Widget build(BuildContext context) {
    return QRCodeData == null || isloading == false
        ? const CircularProgressIndicator()
        : Scaffold(
            backgroundColor: Colors.green[50],
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(children: [
                  const SizedBox(
                    height: 50,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.amber[200],
                    child: Padding(
                      padding: const EdgeInsets.all(4), // Border radius
                      child: ClipOval(
                          child: Image.asset('assets/icons/profile.png')),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    QRCodeData["employee_name"].toString(),
                    style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    (QRCodeData["employee_code"].toString()),
                    style: TextStyle(fontSize: 15, color: Colors.green[900]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 250.0,
                    height: 250.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2, //                   <--- border width here
                      ),
                    ),
                    child: Image.memory(
                      convertBase64Image(QRCodeData['qr_code']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Scan QR Code",
                    style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "With a device built into the company to record your today's attendance",
                    style: TextStyle(fontSize: 15, color: Colors.grey[900]),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
          );
  }
}
