import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_report.dart';

class FirebaseReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StudentReport> getStudentReport(String studentId) async {
    try {
      final scoresData = await _getRecentScores(studentId);
      final skillsData = await _getSkillProgress(studentId);
      final achievementData = await _getLatestAchievement(studentId);
      final attendanceRate = await _getAttendanceRate(studentId);

      return StudentReport(
        overallGrade: _calculateOverallGrade(scoresData),
        attendanceRate: attendanceRate,
        progressRate: _calculateProgressRate(scoresData),
        recentScores: scoresData,
        skillProgress: skillsData,
        latestAchievement: achievementData,
      );
    } catch (e) {
      print('Error fetching report: $e');
      return StudentReport(
        overallGrade: 'N/A',
        attendanceRate: 0.0,
        progressRate: 0.0,
        recentScores: [],
        skillProgress: [],
        latestAchievement: null,
      );
    }
  }

  Future<List<RecentScore>> _getRecentScores(String studentId) async {
    final submissionsQuery = await _firestore
        .collection('submissions')
        .where('student_id', isEqualTo: studentId)
        .where('status', isEqualTo: 'completed')
        .orderBy('completed_at', descending: true)
        .limit(5)
        .get();

    return submissionsQuery.docs.map((doc) {
      final data = doc.data();
      return RecentScore(
        title: data['assessment_title'] ?? 'Assessment',
        date: _formatDate(data['completed_at']),
        score: '${data['score'] ?? 0}%',
      );
    }).toList();
  }

  Future<List<SkillProgress>> _getSkillProgress(String studentId) async {
    final skillsQuery = await _firestore
        .collection('skill_progress')
        .where('student_id', isEqualTo: studentId)
        .get();

    return skillsQuery.docs.map((doc) {
      final data = doc.data();
      return SkillProgress(
        skill: data['skill_name'] ?? '',
        progress: (data['progress'] ?? 0.0).toDouble(),
        level: data['level'] ?? 'Beginner',
      );
    }).toList();
  }

  Future<Achievement?> _getLatestAchievement(String studentId) async {
    final achievementsQuery = await _firestore
        .collection('achievements')
        .where('student_id', isEqualTo: studentId)
        .orderBy('unlocked_at', descending: true)
        .limit(1)
        .get();

    if (achievementsQuery.docs.isNotEmpty) {
      final data = achievementsQuery.docs.first.data();
      return Achievement(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        unlockedDate: _formatDate(data['unlocked_at']),
      );
    }
    return null;
  }

  Future<double> _getAttendanceRate(String studentId) async {
    final attendanceQuery = await _firestore
        .collection('attendance')
        .where('student_id', isEqualTo: studentId)
        .get();

    final records = attendanceQuery.docs;
    final presentCount = records.where((doc) => doc.data()['status'] == 'Present').length;
    return records.isNotEmpty ? presentCount / records.length : 0.0;
  }

  String _calculateOverallGrade(List<RecentScore> scores) {
    if (scores.isEmpty) return 'N/A';
    
    final totalScore = scores.fold(0.0, (sum, score) {
      final numericScore = double.tryParse(score.score.replaceAll('%', '')) ?? 0.0;
      return sum + numericScore;
    });
    
    final average = totalScore / scores.length;
    
    if (average >= 90) return 'A';
    if (average >= 80) return 'B';
    if (average >= 70) return 'C';
    if (average >= 60) return 'D';
    return 'F';
  }

  double _calculateProgressRate(List<RecentScore> scores) {
    if (scores.isEmpty) return 0.0;
    
    final totalScore = scores.fold(0.0, (sum, score) {
      final numericScore = double.tryParse(score.score.replaceAll('%', '')) ?? 0.0;
      return sum + numericScore;
    });
    
    return (totalScore / scores.length) / 100;
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    final date = (timestamp as Timestamp).toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
}