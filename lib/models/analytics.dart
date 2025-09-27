class AnalyticsData {
  final String id;
  final Map<String, dynamic> statistics;
  final List<PerformanceTrend> performanceTrends;
  final List<TopPerformer> topPerformers;
  final List<AttendancePattern> attendancePatterns;
  final List<SubjectPerformance> subjectPerformances;
  final List<StudentNeedingSupport> studentsNeedingSupport;

  AnalyticsData({
    required this.id,
    required this.statistics,
    required this.performanceTrends,
    required this.topPerformers,
    required this.attendancePatterns,
    required this.subjectPerformances,
    required this.studentsNeedingSupport,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      id: json['id'] ?? '',
      statistics: json['statistics'] ?? {},
      performanceTrends:
          (json['performanceTrends'] as List<dynamic>?)
              ?.map((e) => PerformanceTrend.fromJson(e))
              .toList() ??
          [],
      topPerformers:
          (json['topPerformers'] as List<dynamic>?)
              ?.map((e) => TopPerformer.fromJson(e))
              .toList() ??
          [],
      attendancePatterns:
          (json['attendancePatterns'] as List<dynamic>?)
              ?.map((e) => AttendancePattern.fromJson(e))
              .toList() ??
          [],
      subjectPerformances:
          (json['subjectPerformances'] as List<dynamic>?)
              ?.map((e) => SubjectPerformance.fromJson(e))
              .toList() ??
          [],
      studentsNeedingSupport:
          (json['studentsNeedingSupport'] as List<dynamic>?)
              ?.map((e) => StudentNeedingSupport.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statistics': statistics,
      'performanceTrends': performanceTrends.map((e) => e.toJson()).toList(),
      'topPerformers': topPerformers.map((e) => e.toJson()).toList(),
      'attendancePatterns': attendancePatterns.map((e) => e.toJson()).toList(),
      'subjectPerformances': subjectPerformances
          .map((e) => e.toJson())
          .toList(),
      'studentsNeedingSupport': studentsNeedingSupport
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class PerformanceTrend {
  final String month;
  final String metric;
  final double value;
  final String label;

  PerformanceTrend({
    required this.month,
    required this.metric,
    required this.value,
    required this.label,
  });

  factory PerformanceTrend.fromJson(Map<String, dynamic> json) {
    return PerformanceTrend(
      month: json['month'] ?? '',
      metric: json['metric'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'month': month, 'metric': metric, 'value': value, 'label': label};
  }
}

class TopPerformer {
  final String studentId;
  final String studentName;
  final String assessment;
  final String score;
  final String subject;

  TopPerformer({
    required this.studentId,
    required this.studentName,
    required this.assessment,
    required this.score,
    required this.subject,
  });

  factory TopPerformer.fromJson(Map<String, dynamic> json) {
    return TopPerformer(
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      assessment: json['assessment'] ?? '',
      score: json['score'] ?? '',
      subject: json['subject'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'assessment': assessment,
      'score': score,
      'subject': subject,
    };
  }
}

class AttendancePattern {
  final String day;
  final double value;
  final int count;

  AttendancePattern({
    required this.day,
    required this.value,
    required this.count,
  });

  factory AttendancePattern.fromJson(Map<String, dynamic> json) {
    return AttendancePattern(
      day: json['day'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'value': value, 'count': count};
  }
}

class SubjectPerformance {
  final String subject;
  final double value;
  final String percentage;
  final int averageScore;

  SubjectPerformance({
    required this.subject,
    required this.value,
    required this.percentage,
    required this.averageScore,
  });

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) {
    return SubjectPerformance(
      subject: json['subject'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      percentage: json['percentage'] ?? '',
      averageScore: json['averageScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'value': value,
      'percentage': percentage,
      'averageScore': averageScore,
    };
  }
}

class StudentNeedingSupport {
  final String studentId;
  final String studentName;
  final String issue;
  final String priority;
  final String status;

  StudentNeedingSupport({
    required this.studentId,
    required this.studentName,
    required this.issue,
    required this.priority,
    required this.status,
  });

  factory StudentNeedingSupport.fromJson(Map<String, dynamic> json) {
    return StudentNeedingSupport(
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      issue: json['issue'] ?? '',
      priority: json['priority'] ?? 'MEDIUM',
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'issue': issue,
      'priority': priority,
      'status': status,
    };
  }

  bool get isHighPriority => priority == 'HIGH';
  bool get isMediumPriority => priority == 'MEDIUM';
  bool get isLowPriority => priority == 'LOW';
}
