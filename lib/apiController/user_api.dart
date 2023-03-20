// import 'dart:convert';

// import 'package:ipresenceapp/main.dart';
// import 'package:http/http.dart' as http;

// String? _TAG = "User API Class";

// class UserApi {
//   employeeInTime() async {
//     print("$_TAG in user api in time");
//     String userId = '';
//     String companyId = '';

//     await kAppPreference.getUserLoginResponse().then(
//           (value) => {
//             userId = value?.userId,
//             companyId = value?.companyId,
//           },
//         );
//     try {
//       var response = await http.post(
//         Uri.parse("http://139.59.69.40:3536/api/employee-in-time-attendance"),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(<String, String>{
//           'user_id': userId.toString(),
//           'company_id': companyId.toString()
//         }),
//       );
//       // if (response.) {}

//       return response;
//     } catch (error) {
//       print(error);
//     }
//   }

//   employeeOutTime() async {
//     String userId = '';
//     String companyId = '';

//     await kAppPreference.getUserLoginResponse().then(
//           (value) => {
//             userId = value?.userId,
//             companyId = value?.companyId,
//           },
//         );
//     try {
//       var response = await http.post(
//           Uri.parse(
//               "http://139.59.69.40:3536/api/employee-out-time-attendance"),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(<String, String>{
//             'user_id': userId.toString(),
//             'company_id': companyId.toString()
//           }));

//       return response;
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<bool> employeeInTimeStatus() async {
//     String userId = '';
//     String companyId = '';

//     await kAppPreference.getUserLoginResponse().then(
//           (value) => {
//             userId = value?.userId,
//             companyId = value?.companyId,
//           },
//         );

//     final response = await http.get(Uri.parse(
//         "http://139.59.69.40:3536/api/get-intime/${companyId.toString()}/${userId.toString()}"));
//     final jasonresponse = jsonDecode(response.body);
//     print("$_TAG in time status:${jasonresponse.toString()}");
//     return jasonresponse['intime'];
//   }
// }

import 'dart:convert';

import 'package:ipresenceapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:ipresenceapp/utils/utils.dart';

String? _TAG = "User API Class";

class UserApi {
  employeeInTime() async {
    String? userId = '';
    String? companyId = '';

    await kAppPreference.getUserLoginResponse().then(
          (value) => {
            userId = value?.userId,
            companyId = value?.companyId,
          },
        );
    if (userId != null) {
      DateTime currentDate = UtilsHelper.getLocalTime();
      var inTimeResponse = await kAppPreference.getInTimeAttendance();
      int dayDifference = -1;

      if (inTimeResponse != null) {
        final DateTime inTimeDate = DateTime.parse("$inTimeResponse");
        DateTime daySubtract = currentDate.subtract(const Duration(days: 1));
        dayDifference = daySubtract.difference(inTimeDate).inDays;
      }

      if (await kAppPreference.getInTimeAttendance() == null ||
          dayDifference != 0) {
        try {
          var response = await http.post(
            Uri.parse(
                "http://139.59.69.40:3536/api/employee-in-time-attendance"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'user_id': userId.toString(),
              'company_id': companyId.toString()
            }),
          );
          if (response.statusCode == 200) {
            // return response;
            await kAppPreference.setInTimeAttendance(
                "${UtilsHelper.getDateTimeFormatted(UtilsHelper.getLocalTime().toString())}");
            await kAppPreference.removeOutTimeAttendance();
          }
        } catch (error) {
          print(error);
        }
      } else {
        await kAppPreference.setWifiRangeTime(
            "${UtilsHelper.getDateTimeFormatted(UtilsHelper.getLocalTime().toString())}");
      }
    }
  }

  employeeOutTime() async {
    String? userId = '';
    String? companyId = '';

    await kAppPreference.getUserLoginResponse().then(
          (value) => {
            userId = value?.userId,
            companyId = value?.companyId,
          },
        );

    if (await kAppPreference.getInTimeAttendance() != null) {
      if (await kAppPreference.getOutTimeAttendance() != null) {
        return;
      }
      if (await kAppPreference.getWifiRangeTime() == null) {
        return;
      }

      var inTimeResponse = await kAppPreference.getInTimeAttendance();
      final DateTime inTimeResponseFormatted =
          UtilsHelper.getDateTimeFormatted(inTimeResponse);

      var dayDifference =
          UtilsHelper.getLocalTime().difference(inTimeResponseFormatted).inDays;

      var previousWifiRangeTime = await kAppPreference.getWifiRangeTime();

      final DateTime wifiRangeTime =
          UtilsHelper.getDateTimeFormatted(previousWifiRangeTime);

      DateTime minuteSubtract =
          UtilsHelper.getLocalTime().subtract(const Duration(minutes: 1));
      var minuteDifference = minuteSubtract.difference(wifiRangeTime).inMinutes;

      if (await kAppPreference.getInTimeAttendance() != null &&
          await kAppPreference.getOutTimeAttendance() == null &&
          dayDifference == 0 &&
          minuteDifference > 1) {
        try {
          var response = await http.post(
              Uri.parse(
                  "http://139.59.69.40:3536/api/employee-out-time-attendance"),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode(<String, String>{
                'user_id': userId.toString(),
                'company_id': companyId.toString()
              }));
          if (response.statusCode == 200) {
            await kAppPreference
                .setOutTimeAttendance("${UtilsHelper.getLocalTime()}");
            await kAppPreference.removeInTimeAttendance();
          }
        } catch (error) {
          print(error);
        }
      }
    }
  }

  Future<bool> employeeInTimeStatus() async {
    String userId = '';
    String companyId = '';

    await kAppPreference.getUserLoginResponse().then(
          (value) => {
            userId = value?.userId,
            companyId = value?.companyId,
          },
        );

    final response = await http.get(Uri.parse(
        "http://139.59.69.40:3536/api/get-intime/${companyId.toString()}/${userId.toString()}"));
    final jasonresponse = jsonDecode(response.body);

    return jasonresponse['intime'];
  }
}
