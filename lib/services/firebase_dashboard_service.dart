import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_dashboard.dart';

class FirebaseDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<StudentDashboard> getStudentDashboard(String studentId) async {
    try {
      final user = _auth.currentUser;
      final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Student';

      final attendanceData = await _getAttendanceData(studentId);
      final assessmentData = await _getAssessmentData(studentId);
      final activityData = await _getRecentActivity(studentId);

      return StudentDashboard(
        userName: userName,
        attendance: attendanceData['rate'] ?? 0.0,
        overallGrade: attendanceData['grade'] ?? 'N/A',
        completedAssessments: assessmentData['completed'] ?? 0,
        totalAssessments: assessmentData['total'] ?? 0,
        upcomingAssessments: assessmentData['upcoming'] ?? [],
        recentActivity: activityData,
      );
    } catch (e) {
      print('Error fetching dashboard: $e');
      return StudentDashboard(
        userName: 'Student',
        attendance: 0.0,
        overallGrade: 'N/A',
        completedAssessments: 0,
        totalAssessments: 0,
        upcomingAssessments: [],
        recentActivity: [],
      );
    }
  }

  Future<Map<String, dynamic>> _getAttendanceData(String studentId) async {
    final attendanceQuery = await _firestore
        .collection('attendance')
        .where('student_id', isEqualTo: studentId)
        .get();

    final records = attendanceQuery.docs;
    final presentCount = records.where((doc) => doc.data()['status'] == 'Present').length;
    final rate = records.isNotEmpty ? presentCount / records.length : 0.0;

    return {'rate': rate, 'grade': 'A-'};
  }

  Future<Map<String, dynamic>> _getAssessmentData(String studentId) async {
    final submissionsQuery = await _firestore
        .collection('submissions')
        .where('student_id', isEqualTo: studentId)
        .get();

    final assessmentsQuery = await _firestore.collection('assessments').get();
    final completed = submissionsQuery.docs.where((doc) => doc.data()['status'] == 'completed').length;

    final upcomingAssessments = assessmentsQuery.docs
        .where((doc) => !submissionsQuery.docs.any((sub) => sub.data()['assessment_id'] == doc.id))
        .take(3)
        .map((doc) => {
          'title': doc.data()['title'] ?? '',
          'date': doc.data()['due_date'] ?? '',
          'type': doc.data()['type'] ?? 'Quiz',
        })
        .toList();

    return {
      'completed': completed,
      'total': assessmentsQuery.docs.length,
      'upcoming': upcomingAssessments,
    };
  }

  Future<List<Map<String, String?>>> _getRecentActivity(String studentId) async {
    final submissionsQuery = await _firestore
        .collection('submissions')
        .where('student_id', isEqualTo: studentId)
        .orderBy('completed_at', descending: true)
        .limit(4)
        .get();

    return submissionsQuery.docs.map((doc) {
      final data = doc.data();
      return {
        'title': 'Completed ${data['assessment_title'] ?? 'Assessment'}',
        'time': _formatTime(data['completed_at']),
        'score': data['score']?.toString(),
      };
    }).toList();
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return 'Recently';
    final date = (timestamp as Timestamp).toDate();
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    return '${difference.inMinutes} minutes ago';
  }
}