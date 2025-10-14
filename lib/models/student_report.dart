class StudentReport {
  final String overallGrade;
  final double attendanceRate;
  final double progressRate;
  final List<RecentScore> recentScores;
  final List<SkillProgress> skillProgress;
  final Achievement? latestAchievement;

  StudentReport({
    required this.overallGrade,
    required this.attendanceRate,
    required this.progressRate,
    required this.recentScores,
    required this.skillProgress,
    this.latestAchievement,
  });

  factory StudentReport.fromJson(Map<String, dynamic> json) {
    return StudentReport(
      overallGrade: json['overallGrade'] ?? 'N/A',
      attendanceRate: (json['attendanceRate'] ?? 0.0).toDouble(),
      progressRate: (json['progressRate'] ?? 0.0).toDouble(),
      recentScores: (json['recentScores'] as List<dynamic>? ?? [])
          .map((score) => RecentScore.fromJson(score))
          .toList(),
      skillProgress: (json['skillProgress'] as List<dynamic>? ?? [])
          .map((skill) => SkillProgress.fromJson(skill))
          .toList(),
      latestAchievement: json['latestAchievement'] != null
          ? Achievement.fromJson(json['latestAchievement'])
          : null,
    );
  }
}

class RecentScore {
  final String title;
  final String date;
  final String score;

  RecentScore({
    required this.title,
    required this.date,
    required this.score,
  });

  factory RecentScore.fromJson(Map<String, dynamic> json) {
    return RecentScore(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      score: json['score'] ?? '',
    );
  }
}

class SkillProgress {
  final String skill;
  final double progress;
  final String level;

  SkillProgress({
    required this.skill,
    required this.progress,
    required this.level,
  });

  factory SkillProgress.fromJson(Map<String, dynamic> json) {
    return SkillProgress(
      skill: json['skill'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      level: json['level'] ?? '',
    );
  }
}

class Achievement {
  final String title;
  final String description;
  final String unlockedDate;

  Achievement({
    required this.title,
    required this.description,
    required this.unlockedDate,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      unlockedDate: json['unlockedDate'] ?? '',
    );
  }
}