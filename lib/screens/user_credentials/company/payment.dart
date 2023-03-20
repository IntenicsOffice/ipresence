import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/screens/user_credentials/user/user_login.dart';
import '../../../constants/app_sizes.dart';

String? _TAG = "Ipresence Company Payment";

class CompanyPayment extends StatelessWidget {
  String? businessid;
  CompanyPayment({super.key, this.businessid});

  TextEditingController otpController = TextEditingController();

  Future<void> registerFunction(
    BuildContext context,
    String otpString,
  ) async {
    final response = await http.post(
      Uri.parse("http://139.59.69.40:3536/api/payment"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "payment": 10000,
          "company_id": businessid,
        },
      ),
    );

    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return UserLogin();
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => {
            // PageNavigator(ctx: context).nextPageOnly(page: ProductKeyVerification())
            Navigator.pop(context)
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: const [
                        Text(
                          "Payment Verification",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        child: Container(
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Text(
                            "10000",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          registerFunction(
                            context,
                            otpController.text,
                          );
                        },
                        child: Container(
                          color: primaryColor,
                          width: width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: const Text(
                            textAlign: TextAlign.center,
                            "Submit Payment",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
