import 'package:flutter/material.dart';
import 'package:ipresenceapp/components/button.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/components/square_tile.dart';
import 'package:ipresenceapp/providers/CompanyLoginResponseProvider.dart';
import 'package:ipresenceapp/providers/auth/companyAuthentication.dart';
import 'package:ipresenceapp/screens/user_credentials/company/company_register.dart';
import 'package:ipresenceapp/screens/user_credentials/user/user_login.dart';
import 'package:ipresenceapp/utils/routers.dart';
import 'package:ipresenceapp/utils/snack_message.dart';
import 'package:provider/provider.dart';

String? _TAG = "Ipresence Company Login";

class CompanyLogin extends StatefulWidget {
  const CompanyLogin({super.key});

  @override
  State<CompanyLogin> createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {
  final TextEditingController _mobileNo = TextEditingController();
  final TextEditingController _companyPassword = TextEditingController();

  @override
  void dispose() {
    _mobileNo.clear();
    _companyPassword.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CompanyLoginResponseProvider companyLoginResponseProvider =
        Provider.of<CompanyLoginResponseProvider>(context);
    CompanyAuthentication auth =
        new CompanyAuthentication(companyLoginResponseProvider);

    return Scaffold(
        // backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Company Login'),
          centerTitle: true,
          backgroundColor: Colors.green[700],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => {
              PageNavigator(ctx: context).nextPageOnly(page: const UserLogin())
            },
          ),
        ),
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
                    // const Icon(
                    //   Icons.login,
                    //   size: 100,s
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Image.asset(
                      'assets/icons/i_presence_logo.png',
                      height: 100,
                    ),
                    // Text(
                    //   "Company Login",
                    //   style: TextStyle(
                    //       color: Colors.green[800],
                    //       fontSize: 22,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Text(
                    //   "Welcome back to login again",
                    //   style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      hintText: "Mobile no",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      controller: _mobileNo,
                      obsecureText: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: "Password",
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.black,
                      ),
                      controller: _companyPassword,
                      obsecureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Forgot Password?"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customButton(
                      text: 'Login',
                      tap: () {
                        if (_mobileNo.text.isEmpty ||
                            _companyPassword.text.isEmpty) {
                          showMessage(
                              message: "All fields are required",
                              context: context);
                        } else {
                          auth.loginCompany(
                              context: context,
                              mobile: _mobileNo.text.trim(),
                              password: _companyPassword.text.trim());
                        }
                      },
                      context: context,
                      status: auth.isLoading,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Or continue with",
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 12),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Squaretile(
                          imagePath: 'assets/icons/google.png',
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Squaretile(
                          imagePath: 'assets/icons/linkedin.png',
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Squaretile(
                          imagePath: 'assets/icons/website.png',
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Squaretile(
                          imagePath: 'assets/icons/whatsapp.png',
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_circle_left,
                          size: 18,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            PageNavigator(ctx: context)
                                .nextPageOnly(page: const UserLogin());
                          },
                          child: Text(
                            "Employee Login",
                            style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont't have an account?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              PageNavigator(ctx: context)
                                  .nextPageOnly(page: CompanyRegister());
                            },
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )));
  }
}
