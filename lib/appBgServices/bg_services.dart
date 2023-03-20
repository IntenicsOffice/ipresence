import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:better_wifi_manager/better_wifi_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? _TAG = "I=P Ipresence BgServices";

class BgServices {
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
        initialNotificationTitle: 'AWESOME SERVICE',
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

  Future<bool> fetchdt() async {
    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/get-intime/63a1322ef29c2f7f2ef6bef4/63a137a2f29c2f7f2ef6bfac"));
    final jasonresponse = jsonDecode(response.body);
    return jasonresponse['intime'];
  }

  void postInTimeAttendance() async {
    var res = await http.post(
        Uri.parse("http://139.59.69.40:3536/api/employee-in-time-attendance"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': '63a137a2f29c2f7f2ef6bfac',
          'company_id': '63a1322ef29c2f7f2ef6bef4'
        }));
    print(json.encode(res.body));
  }

  void postOutTimeAttendance() async {
    bool inStatus = await fetchdt();

    if (inStatus == true) {
      await http.post(
          Uri.parse(
              "http://139.59.69.40:3536/api/employee-out-time-attendance"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'user_id': '63a137a2f29c2f7f2ef6bfac',
            'company_id': '63a1322ef29c2f7f2ef6bef4'
          }));
    }
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
    Timer.periodic(const Duration(seconds: 45), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.
          flutterLocalNotificationsPlugin.show(
            888,
            'COOL SERVICE',
            'Awesome ${DateTime.now()}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );

          // if you don't using custom notification, uncomment this
          service.setForegroundNotificationInfo(
            title: "My App Service",
            content: "Updated at ${DateTime.now()}",
          );
        }
      }

      /// you can see this log in logcat
      // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
      // postOutTimeAttendance();

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

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          final wifiManager = BetterWifiManager();
          List<WifiScanResult> wifiScanResult = [];
          var scanResultSubscription;
          scanResultSubscription?.cancel();
          scanResultSubscription = wifiManager.scanResultStream.listen((event) {
            scanResultSubscription?.cancel();
            final scanResult = event["scanResult"].toString();
            if (scanResult.isNotEmpty) {
              List<WifiScanResult> wifiScanResultList = jsonDecode(scanResult)
                  .map((e) {
                    return WifiScanResult().wifiScanResultEntityFromJson(e);
                  })
                  .cast<WifiScanResult>()
                  .toList();

              wifiScanResultList.forEach((wifi) {
                if (wifi.SSID == "Intenics Pvt. Ltd. 2") {

                  // postInTimeAttendance();

                  //change ssid here
                  flutterLocalNotificationsPlugin.show(
                    777,
                    'You are nearby our service zone',
                    'frequency: ${wifi.frequency} ssid: ${wifi.SSID}',
                    const NotificationDetails(
                      android: AndroidNotificationDetails(
                        'my_bg',
                        'MY bg SERVICE',
                        icon: 'ic_bg_service_small',
                        ongoing: false,
                      ),
                    ),
                  );
                }
              });
            }
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
}
