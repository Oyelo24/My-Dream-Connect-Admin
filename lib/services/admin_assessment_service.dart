import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAssessmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getAssessmentStats() async {
    try {
      final assessmentsQuery = await _firestore.collection('assessments').get();
      final submissionsQuery = await _firestore.collection('submissions').get();

      final totalAssessments = assessmentsQuery.docs.length;
      final now = DateTime.now();
      
      int completedCount = 0;
      int activeCount = 0;
      int upcomingCount = 0;
      double totalScore = 0;
      int scoredSubmissions = 0;

      for (final doc in assessmentsQuery.docs) {
        final data = doc.data();
        final dueDate = data['due_date'] as Timestamp?;
        
        if (dueDate != null) {
          final due = dueDate.toDate();
          if (due.isBefore(now)) {
            completedCount++;
          } else if (due.isAfter(now) && due.difference(now).inDays <= 7) {
            activeCount++;
          } else {
            upcomingCount++;
          }
        }
      }

      for (final doc in submissionsQuery.docs) {
        final score = doc.data()['score'];
        if (score != null) {
          totalScore += score.toDouble();
          scoredSubmissions++;
        }
      }

      final avgScore = scoredSubmissions > 0 ? totalScore / scoredSubmissions : 0.0;

      return {
        'totalAssessments': totalAssessments,
        'completedCount': completedCount,
        'activeCount': activeCount,
        'upcomingCount': upcomingCount,
        'avgScore': avgScore,
      };
    } catch (e) {
      return {
        'totalAssessments': 0,
        'completedCount': 0,
        'activeCount': 0,
        'upcomingCount': 0,
        'avgScore': 0.0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getAssessments() async {
    try {
      final assessmentsQuery = await _firestore
          .collection('assessments')
          .orderBy('created_at', descending: true)
          .get();

      final assessmentsList = <Map<String, dynamic>>[];

      for (final doc in assessmentsQuery.docs) {
        final data = doc.data();
        
        // Get submissions for this assessment
        final submissionsQuery = await _firestore
            .collection('submissions')
            .where('assessment_id', isEqualTo: doc.id)
            .get();

        final totalSubmissions = submissionsQuery.docs.length;
        final totalStudents = await _getTotalStudents();
        final submissionRate = totalStudents > 0 ? totalSubmissions / totalStudents : 0.0;
        
        // Calculate average score
        double totalScore = 0;
        int scoredSubmissions = 0;
        for (final sub in submissionsQuery.docs) {
          final score = sub.data()['score'];
          if (score != null) {
            totalScore += score.toDouble();
            scoredSubmissions++;
          }
        }
        final avgScore = scoredSubmissions > 0 ? totalScore / scoredSubmissions : 0.0;

        // Determine status
        String status = 'Upcoming';
        final dueDate = data['due_date'] as Timestamp?;
        if (dueDate != null) {
          final due = dueDate.toDate();
          final now = DateTime.now();
          if (due.isBefore(now)) {
            status = 'Completed';
          } else if (due.difference(now).inDays <= 7) {
            status = 'Active';
          }
        }

        assessmentsList.add({
          'id': doc.id,
          'title': data['title'] ?? 'Untitled Assessment',
          'type': data['type'] ?? 'Quiz',
          'status': status,
          'dueDate': dueDate != null ? _formatDate(dueDate.toDate()) : 'No due date',
          'duration': data['duration'] ?? '30 min',
          'totalMarks': data['total_marks'] ?? 100,
          'submissionRate': submissionRate,
          'totalSubmissions': totalSubmissions,
          'totalStudents': totalStudents,
          'avgScore': avgScore,
          'course': data['course'] ?? 'General',
        });
      }

      return assessmentsList;
    } catch (e) {
      return [];
    }
  }

  Future<bool> createAssessment(Map<String, dynamic> assessmentData) async {
    try {
      await _firestore.collection('assessments').add({
        ...assessmentData,
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getTotalStudents() async {
    try {
      final studentsQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();
      return studentsQuery.docs.length;
    } catch (e) {
      return 0;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}