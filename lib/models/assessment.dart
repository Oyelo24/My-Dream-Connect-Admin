enum AssessmentStatus { active, completed, draft, scheduled }

extension AssessmentStatusExtension on AssessmentStatus {
  String get displayName {
    switch (this) {
      case AssessmentStatus.active:
        return 'Active';
      case AssessmentStatus.completed:
        return 'Completed';
      case AssessmentStatus.draft:
        return 'Draft';
      case AssessmentStatus.scheduled:
        return 'Scheduled';
    }
  }

  String get shortName {
    switch (this) {
      case AssessmentStatus.active:
        return 'active';
      case AssessmentStatus.completed:
        return 'completed';
      case AssessmentStatus.draft:
        return 'draft';
      case AssessmentStatus.scheduled:
        return 'scheduled';
    }
  }
}

class Assessment {
  final String id;
  final String title;
  final String subject;
  final String duration;
  final String questions;
  final AssessmentStatus status;
  final String completion;
  final String performance;
  final String createdDate;
  final String? description;
  final int totalQuestions;
  final int totalStudents;

  Assessment({
    required this.id,
    required this.title,
    required this.subject,
    required this.duration,
    required this.questions,
    required this.status,
    required this.completion,
    required this.performance,
    required this.createdDate,
    this.description,
    this.totalQuestions = 0,
    this.totalStudents = 0,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      duration: json['duration'] ?? '',
      questions: json['questions'] ?? '',
      status: AssessmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AssessmentStatus.draft,
      ),
      completion: json['completion'] ?? '0/0',
      performance: json['performance'] ?? '',
      createdDate: json['createdDate'] ?? '',
      description: json['description'],
      totalQuestions: json['totalQuestions'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'duration': duration,
      'questions': questions,
      'status': status.name,
      'completion': completion,
      'performance': performance,
      'createdDate': createdDate,
      'description': description,
      'totalQuestions': totalQuestions,
      'totalStudents': totalStudents,
    };
  }

  // Helper methods
  bool get isActive => status == AssessmentStatus.active;
  bool get isCompleted => status == AssessmentStatus.completed;
  bool get isDraft => status == AssessmentStatus.draft;
  bool get isScheduled => status == AssessmentStatus.scheduled;

  List<String> get completionParts => completion.split('/');
  int get completedCount => int.tryParse(completionParts.first) ?? 0;
  int get totalCount => int.tryParse(completionParts.last) ?? 0;
  double get completionPercentage =>
      totalCount > 0 ? completedCount / totalCount : 0.0;
}
