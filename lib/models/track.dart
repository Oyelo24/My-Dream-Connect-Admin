class Track {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int duration; // in weeks
  final bool isActive;
  final int enrolledStudents;

  Track({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.duration,
    this.isActive = true,
    this.enrolledStudents = 0,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      duration: json['duration'] ?? 12,
      isActive: json['isActive'] ?? true,
      enrolledStudents: json['enrolledStudents'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'duration': duration,
      'isActive': isActive,
      'enrolledStudents': enrolledStudents,
    };
  }
}