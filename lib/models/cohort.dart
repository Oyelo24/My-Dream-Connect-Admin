class Cohort {
  final String id;
  final String name;
  final String track; // Frontend, Backend, Fullstack, etc.
  final DateTime startDate;
  final DateTime endDate;
  final int totalStudents;
  final String status; // Active, Completed, Upcoming

  Cohort({
    required this.id,
    required this.name,
    required this.track,
    required this.startDate,
    required this.endDate,
    required this.totalStudents,
    required this.status,
  });

  factory Cohort.fromJson(Map<String, dynamic> json) {
    return Cohort(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      track: json['track'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      totalStudents: json['total_students'] ?? 0,
      status: json['status'] ?? 'Active',
    );
  }
}