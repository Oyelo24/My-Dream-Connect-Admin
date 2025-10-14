enum StudentAssessmentStatus { available, completed, upcoming, inProgress }

extension StudentAssessmentStatusExtension on StudentAssessmentStatus {
  String get displayName {
    switch (this) {
      case StudentAssessmentStatus.available:
        return 'Available';
      case StudentAssessmentStatus.completed:
        return 'Completed';
      case StudentAssessmentStatus.upcoming:
        return 'Upcoming';
      case StudentAssessmentStatus.inProgress:
        return 'In Progress';
    }
  }
}

class StudentAssessment {
  final String id;
  final String title;
  final String duration;
  final String questions;
  final StudentAssessmentStatus status;
  final String? score;
  final String? completedDate;
  final String? dueDate;

  StudentAssessment({
    required this.id,
    required this.title,
    required this.duration,
    required this.questions,
    required this.status,
    this.score,
    this.completedDate,
    this.dueDate,
  });

  factory StudentAssessment.fromJson(Map<String, dynamic> json) {
    return StudentAssessment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      questions: json['questions'] ?? '',
      status: StudentAssessmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StudentAssessmentStatus.available,
      ),
      score: json['score'],
      completedDate: json['completedDate'],
      dueDate: json['dueDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'questions': questions,
      'status': status.name,
      'score': score,
      'completedDate': completedDate,
      'dueDate': dueDate,
    };
  }
}