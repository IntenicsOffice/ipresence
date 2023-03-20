import 'package:intl/intl.dart';

class UtilsHelper {
  static String DATE_TIME_FORMAT = "yyyy-MM-dd hh:mm";

  static DateTime getLocalTime() {
    DateTime dateTimeNowFormatted = DateTime.now();

    dateTimeNowFormatted =
        DateFormat(DATE_TIME_FORMAT).parse(dateTimeNowFormatted.toString());

    return dateTimeNowFormatted;
  }

  static DateTime getDateTimeFormatted(String dateTime) {
    DateTime dateTimeNowFormatted = DateTime.now();

    dateTimeNowFormatted = DateFormat(DATE_TIME_FORMAT).parse(dateTime);

    return dateTimeNowFormatted;
  }
}
