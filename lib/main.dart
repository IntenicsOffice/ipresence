import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ipresenceapp/apiController/user_api.dart';
import 'package:ipresenceapp/models/CompanyLoginResponse.dart';
import 'package:ipresenceapp/models/UserLoginResponse.dart';
import 'package:ipresenceapp/preferences/ipresence_preferences.dart';
import 'package:ipresenceapp/providers/CompanyLoginResponseProvider.dart';
import 'package:ipresenceapp/providers/UserLoginResponseProvider.dart.dart';
import 'package:ipresenceapp/splash.dart';
import 'package:ipresenceapp/utils/utils.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:better_wifi_manager/better_wifi_manager.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();
UserLoginResponse? kUserLoginResponse;
CompanyLoginResponse? kCompanyLoginResponse;
IpresencePreferences kAppPreference = IpresencePreferences();

String? _TAG = "IP=Main";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
    Permission.notification,
  ].request();

  kAppPreference.init();
  await initializeService();
  await initService();

  // if (statuses[Permission.location.isGranted] != null) {
  //   print("Location permission is allowed");
  //   if (await Permission.speech.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  // } else {
  //   print("Location permission is not allowed");
  // }

  // if (statuses[Permission.storage.isGranted] != null) {
  //   print("Storage permission is allowed");
  // } else {
  //   print("Storage permission is not allowed");
  // }

  // Permission.location.request().then((value) async {
  //   if (value.isGranted) {
  //     if (Platform.isIOS) {
  //       final result =
  //           await BetterWifiManager.requestTemporaryFullAccuracyAuthorization();
  //       print(result);
  //     }
  //   }
  // });

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserLoginResponseProvider()),
        ChangeNotifierProvider(create: (_) => CompanyLoginResponseProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.green[700],
          ),
          primaryColor: Colors.green[700],
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          // iOS: IOSInitializationSettings(),
          ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'INTENICS PVT. LTD. SERVICES',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

Future<void> initService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_bg', // id
    'MY bg SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
          // iOS: IOSInitializationSettings(),
          ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_bg',
      initialNotificationTitle: 'bg SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 777,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  // Timer.periodic(const Duration(seconds: 45), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       /// OPTIONAL for use custom notification
  //       /// the notification id must be equals with AndroidConfiguration when you call configure() method.
  //       flutterLocalNotificationsPlugin.show(
  //         888,
  //         'COOL SERVICE',
  //         'Awesome ${DateTime.now()}',
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             'my_foreground',
  //             'MY FOREGROUND SERVICE',
  //             icon: 'ic_bg_service_small',
  //             ongoing: true,
  //           ),
  //         ),
  //       );

  //       // if you don't using custom notification, uncomment this
  //       service.setForegroundNotificationInfo(
  //         title: "My App Service",
  //         content: "Updated at ${DateTime.now()}",
  //       );
  //     }
  //   }

  //   /// you can see this log in logcat
  //   // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

  //   // test using external plugin
  //   final deviceInfo = DeviceInfoPlugin();
  //   String? device;
  //   if (Platform.isAndroid) {
  //     final androidInfo = await deviceInfo.androidInfo;
  //     device = androidInfo.model;
  //   }

  //   if (Platform.isIOS) {
  //     final iosInfo = await deviceInfo.iosInfo;
  //     device = iosInfo.model;
  //   }

  //   service.invoke(
  //     'update',
  //     {
  //       "current_date": DateTime.now().toIso8601String(),
  //       "device": device,
  //     },
  //   );
  // });

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        final wifiManager = BetterWifiManager();
        List<WifiScanResult> wifiScanResult = [];
        var scanResultSubscription;
        scanResultSubscription?.cancel();
        scanResultSubscription =
            wifiManager.scanResultStream.listen((event) async {
          scanResultSubscription?.cancel();
          bool hasSSID = false;
          final scanResult = event["scanResult"].toString();
          if (scanResult.isNotEmpty) {
            List<WifiScanResult> wifiScanResultList = jsonDecode(scanResult)
                .map((e) {
                  return WifiScanResult().wifiScanResultEntityFromJson(e);
                })
                .cast<WifiScanResult>()
                .toList();

            wifiScanResultList.forEach((wifi) async {
              if (wifi.SSID == "Intenics Pvt. Ltd. 2") {
                hasSSID = true;
                print("$_TAG if hasSSID=${hasSSID}");
                UserApi().employeeInTime();

                // _saveTime(hasSSID);
                // DateTime currentDate = UtilsHelper.getLocalTime();

                // var inTimeResponse = await kAppPreference.getInTimeAttendance();

                // if (inTimeResponse != null) {
                //   return;
                // }

                // print("$_TAG if in time res == $inTimeResponse");
                // int dayDifference = -1;

                // if (inTimeResponse != null) {
                //   final DateTime inTimeDate = DateTime.parse("$inTimeResponse");
                //   DateTime daySubtract =
                //       currentDate.subtract(const Duration(days: 1));
                //   dayDifference = daySubtract.difference(inTimeDate).inDays;
                // }

                //conditions

                // if (await kAppPreference.getInTimeAttendance() == null ||
                //     dayDifference != 0) {
                //   await UserApi().employeeInTime();

                // if (res == 200) {
                //   await kAppPreference.setInTimeAttendance(
                //       "${UtilsHelper.getDateTimeFormatted(UtilsHelper.getLocalTime().toString())}");
                //   await kAppPreference.removeOutTimeAttendance();
                // }
                // } else {
                //   await kAppPreference.setWifiRangeTime(
                //       "${UtilsHelper.getDateTimeFormatted(UtilsHelper.getLocalTime().toString())}");
                // }

                //change ssid here
                flutterLocalNotificationsPlugin.show(
                  777,
                  'Intenics Pvt. Ltd.',
                  'In time: ${await kAppPreference.getInTimeAttendance()}, Last wifirange time: ${await kAppPreference.getWifiRangeTime()}',
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'my_bg',
                      'MY bg SERVICE',
                      icon: 'ic_bg_service_small',
                      ongoing: false,
                    ),
                  ),
                );
              } else {
                hasSSID = false;
                print("$_TAG else hasSSID=${hasSSID}");
                UserApi().employeeOutTime();

                var outTimeResponse =
                    await kAppPreference.getInTimeAttendance();
                flutterLocalNotificationsPlugin.show(
                  777,
                  'Intenics Pvt. Ltd',
                  'Out time: $outTimeResponse',
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'my_bg',
                      'MY bg SERVICE',
                      icon: 'ic_bg_service_small',
                      ongoing: true,
                    ),
                  ),
                );

                // flutterLocalNotificationsPlugin.show(
                //   777,
                //   'Intenics Pvt. Ltd.',
                //   '${await kAppPreference.getOutTimeAttendance()}',
                //   const NotificationDetails(
                //     android: AndroidNotificationDetails(
                //       'my_bg',
                //       'MY bg SERVICE',
                //       icon: 'ic_bg_service_small',
                //       ongoing: false,
                //     ),
                //   ),
                // );
                // print(("$_TAG else part in upper $hasSSID"));
                // // _saveTime(hasSSID);
                // var outTimeResponse =
                //     await kAppPreference.getOutTimeAttendance();
                // print("$_TAG outTimeResponse = $outTimeResponse");

                // if (outTimeResponse != null) {
                //   return;
                // }

                // var previousWifiRangeTime =
                //     await kAppPreference.getWifiRangeTime();
                // var inTimeResponse = await kAppPreference.getInTimeAttendance();
                // print("$_TAG previousWifiRangeTime = $previousWifiRangeTime");
                // print("$_TAG inTimeResponse = $inTimeResponse");

                // if (previousWifiRangeTime == null || inTimeResponse == null) {
                //   return;
                // }

                // final DateTime inTimeResponseFormatted =
                //     UtilsHelper.getDateTimeFormatted(inTimeResponse);

                // print(
                //     "$_TAG inTimeResponseFormatted = $inTimeResponseFormatted");

                // var dayDifference = UtilsHelper.getLocalTime()
                //     .difference(inTimeResponseFormatted)
                //     .inDays;

                // print("$_TAG dayDifference = $dayDifference");

                // final DateTime wifiRangeTime =
                //     UtilsHelper.getDateTimeFormatted(previousWifiRangeTime);

                // print("$_TAG wifiRangeTime = $wifiRangeTime");

                // DateTime minuteSubtract = UtilsHelper.getLocalTime()
                //     .subtract(const Duration(minutes: 2));
                // var minuteDifference =
                //     minuteSubtract.difference(wifiRangeTime).inMinutes;

                // print("$_TAG minuteDifference = $minuteDifference");

                // if (await kAppPreference.getInTimeAttendance() != null &&
                //     await kAppPreference.getOutTimeAttendance() == null &&
                //     dayDifference == 0 &&
                //     minuteDifference > 3) {
                //   try {
                //     print("$_TAG in if=in");

                //     await UserApi().employeeOutTime();

                //     // if (res.statusCode == 200) {
                //     //   await kAppPreference.setOutTimeAttendance(
                //     //       "${UtilsHelper.getLocalTime()}");
                //     //   await kAppPreference.removeInTimeAttendance();
                //     // }
                //   } catch (e) {
                //     print(e);
                //   }
                // }
              }
              ;
            });
          }
          // _saveTime(hasSSID);
        });
        await wifiManager.scanWifi();
      }
    }

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
  });
}

// employee attendance in time and out time post
_saveTime(
  bool hasSSID,
) async {
  print("$_TAG hasSSID == $hasSSID");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (hasSSID == true) {
    DateTime currentDate = UtilsHelper.getLocalTime();

    var inTimeResponse = await kAppPreference.getInTimeAttendance();

    if (inTimeResponse != null) {
      return;
    }

    print("$_TAG if in time res == $inTimeResponse");
    int dayDifference = -1;

    if (inTimeResponse != null) {
      final DateTime inTimeDate = DateTime.parse("$inTimeResponse");
      DateTime daySubtract = currentDate.subtract(const Duration(days: 1));
      dayDifference = daySubtract.difference(inTimeDate).inDays;
    }

    //conditions
    if (await kAppPreference.getInTimeAttendance() == null ||
        dayDifference != 0) {
      var res = await UserApi().employeeInTime();

      if (res.statusCode == 200) {
        flutterLocalNotificationsPlugin.show(
          777,
          'Welcome to Intenics Pvt. Ltd.',
          'Your today Intime - $inTimeResponse',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
        await kAppPreference.setInTimeAttendance(
            "${UtilsHelper.getDateTimeFormatted(UtilsHelper.getLocalTime().toString())}");
        await kAppPreference.removeOutTimeAttendance();
      }
    } else {
      await kAppPreference.setWifiRangeTime(
          "${UtilsHelper.getDateTimeFormatted(UtilsHelper.getLocalTime().toString())}");
    }
  }

  if (hasSSID == false) {
    var outTimeResponse = await kAppPreference.getOutTimeAttendance();
    print("$_TAG outTimeResponse = $outTimeResponse");

    if (outTimeResponse != null) {
      return;
    }

    var previousWifiRangeTime = await kAppPreference.getWifiRangeTime();
    var inTimeResponse = await kAppPreference.getInTimeAttendance();
    print("$_TAG previousWifiRangeTime = $previousWifiRangeTime");
    print("$_TAG inTimeResponse = $inTimeResponse");

    if (previousWifiRangeTime == null || inTimeResponse == null) {
      return;
    }

    final DateTime inTimeResponseFormatted =
        UtilsHelper.getDateTimeFormatted(inTimeResponse);

    print("$_TAG inTimeResponseFormatted = $inTimeResponseFormatted");

    var dayDifference =
        UtilsHelper.getLocalTime().difference(inTimeResponseFormatted).inDays;

    final DateTime wifiRangeTime =
        UtilsHelper.getDateTimeFormatted(previousWifiRangeTime);

    DateTime minuteSubtract =
        UtilsHelper.getLocalTime().subtract(const Duration(minutes: 2));
    var minuteDifference = minuteSubtract.difference(wifiRangeTime).inMinutes;

    if (await kAppPreference.getInTimeAttendance() != null &&
        await kAppPreference.getOutTimeAttendance() == null &&
        dayDifference == 0 &&
        minuteDifference > 3) {
      try {
        var res = await UserApi().employeeOutTime();

        print("$_TAG employeeOutTime res = ${res.body}");

        if (res.statusCode == 200) {
          flutterLocalNotificationsPlugin.show(
            777,
            'ThankYou!',
            'Your today Outtime - "${UtilsHelper.getLocalTime()}"',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );
          await kAppPreference
              .setOutTimeAttendance("${UtilsHelper.getLocalTime()}");
          // await kAppPreference.removeInTimeAttendance();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}


// <uses-permission android:name="android.permission.INTERNET"/>
//     <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
//     <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
//     <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
//     <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
//     <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
//     <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
//     <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
//     <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
//     <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
//     <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//     <uses-permission android:name="android.permission.VIBRATE" />