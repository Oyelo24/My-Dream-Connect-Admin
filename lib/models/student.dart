class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String enrollmentDate;
  final String lastSeen;
  final String attendance;
  final String grade;
  final String status;
  final String progress;
  final String? avatar;
  final String? track;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.enrollmentDate,
    required this.lastSeen,
    required this.attendance,
    required this.grade,
    required this.status,
    required this.progress,
    this.avatar,
    this.track,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      enrollmentDate: json['enrollmentDate'] ?? '',
      lastSeen: json['lastSeen'] ?? '',
      attendance: json['attendance'] ?? '0%',
      grade: json['grade'] ?? 'N/A',
      status: json['status'] ?? 'INACTIVE',
      progress: json['progress'] ?? '0/0',
      avatar: json['avatar'],
      track: json['track'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'enrollmentDate': enrollmentDate,
      'lastSeen': lastSeen,
      'attendance': attendance,
      'grade': grade,
      'status': status,
      'progress': progress,
      'avatar': avatar,
      'track': track,
    };
  }

  // Helper methods
  double get attendancePercentage =>
      double.parse(attendance.replaceAll('%', '')) / 100;
  bool get isActive => status == 'ACTIVE';
  bool get needsAttention => status == 'HOLD' || attendancePercentage < 0.75;
}
