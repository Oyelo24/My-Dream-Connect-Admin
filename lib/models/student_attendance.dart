class StudentAttendanceRecord {
  final String id;
  final String sessionTitle;
  final String date;
  final String status;
  final String? checkInTime;

  StudentAttendanceRecord({
    required this.id,
    required this.sessionTitle,
    required this.date,
    required this.status,
    this.checkInTime,
  });

  factory StudentAttendanceRecord.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceRecord(
      id: json['id'] ?? '',
      sessionTitle: json['sessionTitle'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'Absent',
      checkInTime: json['checkInTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionTitle': sessionTitle,
      'date': date,
      'status': status,
      'checkInTime': checkInTime,
    };
  }
}

class StudentAttendanceSummary {
  final double attendanceRate;
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final StudentAttendanceRecord? todaySession;
  final List<StudentAttendanceRecord> recentRecords;

  StudentAttendanceSummary({
    required this.attendanceRate,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    this.todaySession,
    required this.recentRecords,
  });

  factory StudentAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceSummary(
      attendanceRate: (json['attendanceRate'] ?? 0.0).toDouble(),
      presentCount: json['presentCount'] ?? 0,
      lateCount: json['lateCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      todaySession: json['todaySession'] != null 
          ? StudentAttendanceRecord.fromJson(json['todaySession'])
          : null,
      recentRecords: (json['recentRecords'] as List<dynamic>? ?? [])
          .map((record) => StudentAttendanceRecord.fromJson(record))
          .toList(),
    );
  }
}