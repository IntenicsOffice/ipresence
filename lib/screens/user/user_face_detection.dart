import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

String? _TAG = "Ipresence User Face Detection";

// ignore: camel_case_types
class UserFaceDetection extends StatefulWidget {
  const UserFaceDetection({Key? key}) : super(key: key);

  @override
  State<UserFaceDetection> createState() => _UserFaceDetectionState();
}

class _UserFaceDetectionState extends State<UserFaceDetection> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    _authenticate();
    super.initState();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Your daily attendance authentication',
        options: const AuthenticationOptions(
            stickyAuth: false, useErrorDialogs: true),
      );
      setState(() {});
    } on PlatformException catch (e) {
      setState(() {
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 150,
            ),
            const Icon(
              Icons.fingerprint,
              color: Colors.green,
              size: 120,
            ),
            Text(
              _authorized,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            // Text(authenticated),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Auth With Fingerprint",
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "authenticate your today's attendance with a fingerprint (touch id)",
              style: TextStyle(
                color: Colors.grey[800],
                // fontSize: 20,
                // fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 70,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800], // Background color
              ),
              onPressed: (() {
                _authenticate();
              }),
              icon: const Icon(
                Icons.fingerprint,
              ),
              label: const Text(
                "Use Authentication",
                style: TextStyle(fontSize: 20),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/error_codes.dart' as local_auth_error;

// class UserFaceDetection extends StatefulWidget {
//   const UserFaceDetection({Key? key}) : super(key: key);

//   @override
//   State<UserFaceDetection> createState() => _UserFaceDetectionState();
// }

// class _UserFaceDetectionState extends State<UserFaceDetection> {
//   final LocalAuthentication auth = LocalAuthentication();
//   bool _isUserAuthorized = false;

//   //
//   void gg() async {
//     final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
//     final bool canAuthenticate =
//         canAuthenticateWithBiometrics || await auth.isDeviceSupported();

//     final List<BiometricType> availableBiometrics =
//         await auth.getAvailableBiometrics();

//     if (availableBiometrics.isNotEmpty) {
//       // Some biometrics are enrolled.
//       print("yes");
//     }

//     if (availableBiometrics.contains(BiometricType.strong) ||
//         availableBiometrics.contains(BiometricType.face)) {
//       // Specific types of biometrics are available.
//       // Use checks like this with caution!
//     }
//   }

//   @override
//   void initState() {
//     authenticateUser();
//     super.initState();
//   }

//   Future<void> authenticateUser() async {
//     bool isAuthorized = false;
//     try {
//       isAuthorized = await _localAuthentication.authenticate(
//         localizedReason: "Please authenticate to see account balance",
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: false,
//         ),
//       );
//     } on PlatformException catch (exception) {
//       if (exception.code == local_auth_error.notAvailable ||
//           exception.code == local_auth_error.passcodeNotSet ||
//           exception.code == local_auth_error.notEnrolled) {
//         // Handle this exception here.
//       }
//     }

//     if (!mounted) return;

//     setState(() {
//       _isUserAuthorized = isAuthorized;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _isUserAuthorized
//                 ? (const Text("Authentication successful!!!"))
//                 : (TextButton(
//                     onPressed: authenticateUser,
//                     child: const Text(
//                       "Authorize now",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Colors.lightBlueAccent),
//                     ),
//                   )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, avoid_print

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// class UserFaceDetection extends StatefulWidget {
//   const UserFaceDetection({Key? key}) : super(key: key);

//   @override
//   State<UserFaceDetection> createState() => _UserFaceDetectionState();
// }

// class _UserFaceDetectionState extends State<UserFaceDetection> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool? _canCheckBiometrics;
//   List<BiometricType>? _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;

//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (bool isSupported) => setState(() => _supportState = isSupported
//               ? _SupportState.supported
//               : _SupportState.unsupported),
//         );
//   }

//   Future<void> _checkBiometrics() async {
//     late bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }

//   Future<void> _getAvailableBiometrics() async {
//     late List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) {
//       return;
//     }

//     setState(() {
//       _availableBiometrics = availableBiometrics;
//     });
//   }

//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason: 'Let OS determine authentication method',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//         ),
//       );
//       setState(() {
//         _isAuthenticating = false;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Error - ${e.message}';
//       });
//       return;
//     }
//     if (!mounted) {
//       return;
//     }

//     setState(
//         () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
//   }

//   Future<void> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason:
//             'Scan your fingerprint (or face or whatever) to authenticate',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Authenticating';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Error - ${e.message}';
//       });
//       return;
//     }
//     if (!mounted) {
//       return;
//     }

//     final String message = authenticated ? 'Authorized' : 'Not Authorized';
//     setState(() {
//       _authorized = message;
//     });
//   }

//   Future<void> _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 if (_supportState == _SupportState.unknown)
//                   const CircularProgressIndicator()
//                 else if (_supportState == _SupportState.supported)
//                   const Text('This device is supported')
//                 else
//                   const Text('This device is not supported'),
//                 const Divider(height: 100),
//                 Text('Can check biometrics: $_canCheckBiometrics\n'),
//                 ElevatedButton(
//                   onPressed: _checkBiometrics,
//                   child: const Text('Check biometrics'),
//                 ),
//                 const Divider(height: 100),
//                 Text('Available biometrics: $_availableBiometrics\n'),
//                 ElevatedButton(
//                   onPressed: _getAvailableBiometrics,
//                   child: const Text('Get available biometrics'),
//                 ),
//                 const Divider(height: 100),
//                 Text('Current State: $_authorized\n'),
//                 if (_isAuthenticating)
//                   ElevatedButton(
//                     onPressed: _cancelAuthentication,
//                     // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
//                     // ignore: prefer_const_constructors
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const <Widget>[
//                         Text('Cancel Authentication'),
//                         Icon(Icons.cancel),
//                       ],
//                     ),
//                   )
//                 else
//                   Column(
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: _authenticate,
//                         // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
//                         // ignore: prefer_const_constructors
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const <Widget>[
//                             Text('Authenticate'),
//                             Icon(Icons.perm_device_information),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _authenticateWithBiometrics,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text(_isAuthenticating
//                                 ? 'Cancel'
//                                 : 'Authenticate: biometrics only'),
//                             const Icon(Icons.fingerprint),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }
