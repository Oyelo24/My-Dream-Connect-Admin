import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class FirebaseCourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Course>> getStudentCourses(String studentId) async {
    try {
      final enrollmentsQuery = await _firestore
          .collection('enrollments')
          .where('student_id', isEqualTo: studentId)
          .get();

      List<Course> courses = [];
      
      for (var doc in enrollmentsQuery.docs) {
        final enrollmentData = doc.data();
        final courseId = enrollmentData['course_id'];
        
        final courseDoc = await _firestore.collection('courses').doc(courseId).get();
        if (courseDoc.exists) {
          final courseData = courseDoc.data()!;
          courses.add(Course(
            id: courseDoc.id,
            title: courseData['title'] ?? '',
            instructor: courseData['instructor'] ?? '',
            progress: (enrollmentData['progress'] ?? 0.0).toDouble(),
            status: _parseStatus(enrollmentData['status'] ?? 'inProgress'),
            grade: enrollmentData['grade'],
            startDate: courseData['start_date'],
            endDate: courseData['end_date'],
            description: courseData['description'],
          ));
        }
      }
      
      return courses;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  CourseStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return CourseStatus.completed;
      case 'upcoming':
        return CourseStatus.upcoming;
      case 'paused':
        return CourseStatus.paused;
      default:
        return CourseStatus.inProgress;
    }
  }
}