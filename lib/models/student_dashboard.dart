class StudentDashboard {
  final String userName;
  final double attendance;
  final String overallGrade;
  final int completedAssessments;
  final int totalAssessments;
  final List<Map<String, String>> upcomingAssessments;
  final List<Map<String, String?>> recentActivity;

  StudentDashboard({
    required this.userName,
    required this.attendance,
    required this.overallGrade,
    required this.completedAssessments,
    required this.totalAssessments,
    required this.upcomingAssessments,
    required this.recentActivity,
  });

  double get assessmentProgress => totalAssessments > 0 ? completedAssessments / totalAssessments : 0.0;

  factory StudentDashboard.fromJson(Map<String, dynamic> json) {
    return StudentDashboard(
      userName: json['userName'] ?? 'Student',
      attendance: (json['attendance'] ?? 0.0).toDouble(),
      overallGrade: json['overallGrade'] ?? 'N/A',
      completedAssessments: json['completedAssessments'] ?? 0,
      totalAssessments: json['totalAssessments'] ?? 0,
      upcomingAssessments: (json['upcomingAssessments'] as List<dynamic>? ?? [])
          .map((item) => Map<String, String>.from(item))
          .toList(),
      recentActivity: (json['recentActivity'] as List<dynamic>? ?? [])
          .map((item) => Map<String, String?>.from(item))
          .toList(),
    );
  }
}