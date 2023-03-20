class Attendance {
  dynamic dateTime;
  String? isAttendance;

  Attendance({this.dateTime, this.isAttendance});

  Attendance.fromJson(Map<String, dynamic> json) {
    dateTime = json['date_time'];
    isAttendance = json['is_attendance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_time'] = this.dateTime;
    data['is_attendance'] = this.isAttendance;
    return data;
  }
}