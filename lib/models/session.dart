class Session {
  final String id;
  final String title;
  final String cohortId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String instructor;
  final String topic;
  final String type; // Lecture, Workshop, Assessment
  final bool isActive;

  Session({
    required this.id,
    required this.title,
    required this.cohortId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.instructor,
    required this.topic,
    required this.type,
    required this.isActive,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      cohortId: json['cohort_id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      instructor: json['instructor'] ?? '',
      topic: json['topic'] ?? '',
      type: json['type'] ?? 'Lecture',
      isActive: json['is_active'] ?? false,
    );
  }
}