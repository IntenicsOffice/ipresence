import 'package:ipresenceapp/Utils/routers.dart';
import 'package:ipresenceapp/components/button.dart';
import 'package:ipresenceapp/components/custom_textfeild.dart';
import 'package:ipresenceapp/components/square_tile.dart';
import 'package:ipresenceapp/providers/UserLoginResponseProvider.dart.dart';
import 'package:ipresenceapp/providers/auth/authentication.dart';
import 'package:ipresenceapp/screens/user_credentials/company/company_login.dart';
import 'package:ipresenceapp/utils/snack_message.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

String? _TAG = "Ipresence User Login";

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController _empId = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // bool companyLogin = false;

  // void onEmployeLogin(String id, String password) async {
  //   final response = await http.post(
  //       Uri.parse("http://139.59.69.40:3536/api/login-employee"),
  //       headers: {"Content-Type": "Application/json"},
  //       body:
  //           jsonEncode(<String, dynamic>{"emp_id": id, "password": password}));

  //   if (response.statusCode == 200) {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setInt("emp_login", 1);

  //     final int? counter = prefs.getInt('emp_login');
  //     final jsonResponse = jsonDecode(response.body);

  //     await prefs.setString("user_data", response.body);

  //     var data = prefs.getString("user_data");

  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return UserTabPage();
  //     }));
  //   } else {}
  // }

  // void onAdminLogin(String id, String password) async {
  //   final response = await http.post(
  //       Uri.parse("http://139.59.69.40:3536/api/company-login"),
  //       headers: {"Content-Type": "Application/json"},
  //       body:
  //           jsonEncode(<String, dynamic>{"mobile": id, "password": password}));

  //   if (response.statusCode == 200) {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setInt("admin_login", 2);

  //     final int? counter = prefs.getInt('admin_login');
  //     final jsonResponse = jsonDecode(response.body);

  //     await prefs.setString("admin_user_data", response.body);

  //     var data = prefs.getString("admin_user_data");

  //     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //       return CompanyTabPage();
  //     }));
  //   } else {}
  // }

  @override
  void dispose() {
    _empId.clear();
    _password.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserLoginResponseProvider userLoginResponseProvider =
        Provider.of<UserLoginResponseProvider>(context);
    Authentication auth = Authentication(userLoginResponseProvider);

    //

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: Colors.grey[200],
        body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Image.asset(
                'assets/icons/i_presence_logo.png',
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Employee Login",
                style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Welcome back to login again",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hintText: "Emp id",
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.black87,
                ),
                controller: _empId,
                obsecureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                hintText: "Password",
                prefixIcon: const Icon(
                  Icons.password,
                  color: Colors.black87,
                ),
                controller: _password,
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
                    Text("Forgot Password ?"),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              customButton(
                text: 'Login',
                tap: () {
                  if (_empId.text.isEmpty || _password.text.isEmpty) {
                    showMessage(
                        message: "All fields are required", context: context);
                  } else {
                    auth.loginUser(
                        context: context,
                        empId: _empId.text.trim(),
                        password: _password.text.trim());
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
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
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      PageNavigator(ctx: context)
                          .nextPageOnly(page: const CompanyLogin());
                    },
                    child: Text(
                      "Company Login",
                      style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.arrow_circle_right,
                    size: 18,
                    color: Colors.black54,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
