import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_assessment.dart';

class FirebaseAssessmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StudentAssessment>> getStudentAssessments(String studentId) async {
    try {
      final assessmentsQuery = await _firestore.collection('assessments').get();
      final submissionsQuery = await _firestore
          .collection('submissions')
          .where('student_id', isEqualTo: studentId)
          .get();

      final submissions = Map.fromIterable(
        submissionsQuery.docs,
        key: (doc) => doc.data()['assessment_id'],
        value: (doc) => doc.data(),
      );

      return assessmentsQuery.docs.map((doc) {
        final assessmentData = doc.data();
        final submission = submissions[doc.id];
        
        return StudentAssessment(
          id: doc.id,
          title: assessmentData['title'] ?? '',
          duration: assessmentData['duration'] ?? '30 min',
          questions: '${assessmentData['total_questions'] ?? 10} questions',
          status: _parseStatus(submission?['status'] ?? 'available'),
          score: submission?['score']?.toString(),
          completedDate: submission?['completed_at'],
          dueDate: assessmentData['due_date'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching assessments: $e');
      return [];
    }
  }

  Future<bool> startAssessment(String assessmentId, String studentId) async {
    try {
      await _firestore.collection('submissions').add({
        'assessment_id': assessmentId,
        'student_id': studentId,
        'status': 'inProgress',
        'started_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error starting assessment: $e');
      return false;
    }
  }

  StudentAssessmentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return StudentAssessmentStatus.completed;
      case 'upcoming':
        return StudentAssessmentStatus.upcoming;
      case 'inprogress':
        return StudentAssessmentStatus.inProgress;
      default:
        return StudentAssessmentStatus.available;
    }
  }
}