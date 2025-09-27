enum AttendanceStatus { present, late, absent, excused }

extension AttendanceStatusExtension on AttendanceStatus {
  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.excused:
        return 'Excused';
    }
  }

  String get shortName {
    switch (this) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.late:
        return 'late';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.excused:
        return 'excused';
    }
  }
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String session;
  final String checkInTime;
  final AttendanceStatus status;
  final String? override;
  final String notes;
  final String date;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.session,
    required this.checkInTime,
    required this.status,
    this.override,
    required this.notes,
    required this.date,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      studentEmail: json['studentEmail'] ?? '',
      session: json['session'] ?? '',
      checkInTime: json['checkInTime'] ?? '',
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      override: json['override'],
      notes: json['notes'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'session': session,
      'checkInTime': checkInTime,
      'status': status.name,
      'override': override,
      'notes': notes,
      'date': date,
    };
  }

  // Helper methods
  bool get isPresent => status == AttendanceStatus.present;
  bool get isLate => status == AttendanceStatus.late;
  bool get isAbsent => status == AttendanceStatus.absent;
  bool get isExcused => status == AttendanceStatus.excused;
  bool get hasOverride => override != null && override!.isNotEmpty;
}
