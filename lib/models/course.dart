enum CourseStatus { inProgress, completed, upcoming, paused }

extension CourseStatusExtension on CourseStatus {
  String get displayName {
    switch (this) {
      case CourseStatus.inProgress:
        return 'In Progress';
      case CourseStatus.completed:
        return 'Completed';
      case CourseStatus.upcoming:
        return 'Upcoming';
      case CourseStatus.paused:
        return 'Paused';
    }
  }
}

class Course {
  final String id;
  final String title;
  final String instructor;
  final double progress;
  final CourseStatus status;
  final String? grade;
  final String? startDate;
  final String? endDate;
  final String? description;

  Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.progress,
    required this.status,
    this.grade,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      status: CourseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => CourseStatus.inProgress,
      ),
      grade: json['grade'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'progress': progress,
      'status': status.name,
      'grade': grade,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }
}