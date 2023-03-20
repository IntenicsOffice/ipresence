import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/Utils/routers.dart';
import 'package:ipresenceapp/components/button.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/screens/user_credentials/company/company_login.dart';
import 'package:ipresenceapp/screens/user_credentials/company/payment.dart';

String? _TAG = "Ipresence Company Product Key Verification";

class ProductKeyVerification extends StatefulWidget {
  String? businessid;
  ProductKeyVerification({super.key, this.businessid});

  @override
  State<ProductKeyVerification> createState() => _ProductKeyVerificationState();
}

class _ProductKeyVerificationState extends State<ProductKeyVerification> {
  TextEditingController _productKey = TextEditingController();

  Future<void> registerFunction(
    BuildContext context,
    String productKey,
  ) async {
    final response = await http.post(
      Uri.parse("http://139.59.69.40:3536/api/verify-product-key"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "product_key": productKey,
          "company_id": widget.businessid,
        },
      ),
    );

    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CompanyPayment(
          businessid: widget.businessid,
        );
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
        title: const Text("Product Key Verification"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        leading: IconButton(
            onPressed: () => {
                  PageNavigator(ctx: context)
                      .nextPageOnly(page: const CompanyLogin())
                },
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Icon(
                      Icons.key,
                      size: 100,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Verify your product key",
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    CustomTextField(
                      controller: _productKey,
                      prefixIcon: const Icon(
                        Icons.dialpad,
                        color: Colors.black45,
                      ),
                      hintText: 'Product key',
                      obsecureText: false,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    customButton(
                        text: 'Verify & continue',
                        tap: () {
                          registerFunction(
                            context,
                            _productKey.text,
                          );
                        },
                        context: context,
                        status: false),

                    //

                    // const Center(
                    //   child: Icon(
                    //     Icons.person_outline_outlined,
                    //     size: 150,
                    //     color: Colors.black54,
                    //   ),
                    // ),
                    // Center(
                    //   child: Container(
                    //     margin: const EdgeInsets.symmetric(horizontal: 20),
                    //     child: Column(
                    //       children: const [
                    //         Text(
                    //           "Product key verification",
                    //           style: TextStyle(
                    //               fontSize: 20, fontWeight: FontWeight.bold),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //         Text(
                    //           "Enter your product key sent to your registered email",
                    //           style: TextStyle(
                    //             fontSize: 18,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: height * 0.1,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Column(
                    //     children: [
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           registerFunction(
                    //             context,
                    //             _productKey.text,
                    //           );
                    //         },
                    //         child: Container(
                    //           color: primaryColor,
                    //           width: width,
                    //           padding: const EdgeInsets.all(8),
                    //           child: const Text(
                    //             textAlign: TextAlign.center,
                    //             "Verify Otp",
                    //             style: TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
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
