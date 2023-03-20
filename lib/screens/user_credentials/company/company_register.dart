import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipresenceapp/Utils/routers.dart';
import 'package:ipresenceapp/components/button.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/screens/user_credentials/company/company_login.dart';
import 'package:ipresenceapp/screens/user_credentials/company/product_key_verification.dart';
import 'package:http/http.dart' as http;

String? _TAG = "Ipresence Company Registration";

class CompanyRegister extends StatelessWidget {
  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();

  CompanyRegister({super.key});

  Future<void> registerFunction(
    BuildContext context,
    String companyName,
    String userName,
    String mobileNo,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse("http://139.59.69.40:3536/api/register-company"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "company_name": companyName,
          "owner_name": userName,
          "mobile": mobileNo,
          "email": email
        },
      ),
    );
    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ProductKeyVerification(businessid: jsonString["_id"].toString());
      }));

      Fluttertoast.showToast(
          msg: jsonString["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } else {
      Fluttertoast.showToast(
          msg: jsonString["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Registration'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => {
            PageNavigator(ctx: context).nextPageOnly(page: const CompanyLogin())
          },
        ),
      ),
      // backgroundColor: const Color(0xfff0fdf4),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Icon(
                      Icons.person_add,
                      size: 100,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Sign up to keep your daily presence \n in your organiztion",
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      controller: _companyName,
                      prefixIcon: const Icon(
                        Icons.blinds_sharp,
                        color: Colors.black87,
                      ),
                      hintText: 'Company name',
                      obsecureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _userName,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black87,
                      ),
                      hintText: "Owner name",
                      obsecureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _mobileNumber,
                      prefixIcon: const Icon(
                        Icons.phone_android_outlined,
                        color: Colors.black87,
                      ),
                      hintText: "Mobile no",
                      obsecureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _email,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black87,
                      ),
                      hintText: "Email",
                      obsecureText: false,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    customButton(
                        text: 'Register & continue',
                        tap: () {
                          registerFunction(context, _companyName.text,
                              _userName.text, _mobileNumber.text, _email.text);
                        },
                        context: context,
                        status: false),
                    // GestureDetector(
                    //   onTap: () {
                    //     registerFunction(context, _companyName.text,
                    //         _userName.text, _mobileNumber.text, _email.text);
                    //   },
                    //   child: Container(
                    //     color: primaryColor,
                    //     width: width,
                    //     padding: const EdgeInsets.all(8),
                    //     child: const Text(
                    //       textAlign: TextAlign.center,
                    //       "Sign Up",
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
