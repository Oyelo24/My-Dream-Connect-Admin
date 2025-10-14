import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analytics.dart';
import '../models/student.dart';

class AdminDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final studentsQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      final assessmentsQuery = await _firestore.collection('assessments').get();
      final attendanceQuery = await _firestore.collection('attendance').get();
      final coursesQuery = await _firestore.collection('courses').get();

      final totalStudents = studentsQuery.docs.length;
      final totalAssessments = assessmentsQuery.docs.length;
      final totalCourses = coursesQuery.docs.length;

      // Calculate attendance rate
      final presentCount = attendanceQuery.docs
          .where((doc) => doc.data()['status'] == 'Present')
          .length;
      final attendanceRate = attendanceQuery.docs.isNotEmpty
          ? (presentCount / attendanceQuery.docs.length * 100)
          : 0.0;

      return {
        'totalStudents': totalStudents,
        'totalAssessments': totalAssessments,
        'totalCourses': totalCourses,
        'attendanceRate': attendanceRate,
      };
    } catch (e) {
      return {
        'totalStudents': 0,
        'totalAssessments': 0,
        'totalCourses': 0,
        'attendanceRate': 0.0,
      };
    }
  }

  Future<List<Student>> getRecentStudents() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .orderBy('enrollment_date', descending: true)
          .limit(5)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Student(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          lastSeen: _formatTime(data['last_seen']),
          enrollmentDate: _formatDate(data['enrollment_date']),
          attendance: '${(data['attendance_rate'] ?? 0).toInt()}%',
          grade: data['grade'] ?? 'N/A',
          status: data['status'] ?? 'Active',
          progress: '${(data['progress'] ?? 0).toInt()}%',
          track: data['track'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity() async {
    try {
      final submissionsQuery = await _firestore
          .collection('submissions')
          .orderBy('completed_at', descending: true)
          .limit(10)
          .get();

      final activities = <Map<String, dynamic>>[];

      for (final doc in submissionsQuery.docs) {
        final data = doc.data();
        final studentDoc = await _firestore
            .collection('users')
            .doc(data['student_id'])
            .get();
        
        final studentName = studentDoc.exists 
            ? (studentDoc.data()?['name'] ?? 'Unknown Student')
            : 'Unknown Student';

        activities.add({
          'type': 'submission',
          'title': 'Assessment Submitted',
          'description': '$studentName submitted ${data['assessment_title'] ?? 'an assessment'}',
          'time': _formatTime(data['completed_at']),
          'icon': 'assignment_turned_in',
          'score': data['score']?.toString(),
        });
      }

      final attendanceQuery = await _firestore
          .collection('attendance')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      for (final doc in attendanceQuery.docs) {
        final data = doc.data();
        final studentDoc = await _firestore
            .collection('users')
            .doc(data['student_id'])
            .get();
        
        final studentName = studentDoc.exists 
            ? (studentDoc.data()?['name'] ?? 'Unknown Student')
            : 'Unknown Student';

        activities.add({
          'type': 'attendance',
          'title': 'Attendance Marked',
          'description': '$studentName marked ${data['status']}',
          'time': _formatTime(data['date']),
          'icon': data['status'] == 'Present' ? 'check_circle' : 'cancel',
        });
      }

      activities.sort((a, b) => b['time'].compareTo(a['time']));
      return activities.take(8).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUpcomingAssessments() async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _firestore
          .collection('assessments')
          .where('due_date', isGreaterThan: Timestamp.fromDate(now))
          .orderBy('due_date')
          .limit(5)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data['title'] ?? 'Untitled Assessment',
          'type': data['type'] ?? 'Quiz',
          'dueDate': _formatDate(data['due_date']),
          'course': data['course'] ?? 'General',
          'totalMarks': data['total_marks'] ?? 0,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<AnalyticsData> getAnalyticsData() async {
    try {
      final stats = await getDashboardStats();
      
      // Mock performance trends - in real app, calculate from historical data
      final performanceTrends = [
        PerformanceTrend(month: 'Jan', metric: 'attendance', value: 85.0, label: '85%'),
        PerformanceTrend(month: 'Feb', metric: 'attendance', value: 88.0, label: '88%'),
        PerformanceTrend(month: 'Mar', metric: 'attendance', value: 92.0, label: '92%'),
        PerformanceTrend(month: 'Apr', metric: 'attendance', value: 87.0, label: '87%'),
      ];

      // Get top performers from submissions
      final topPerformers = await _getTopPerformers();
      
      return AnalyticsData(
        id: 'admin_analytics',
        statistics: stats,
        performanceTrends: performanceTrends,
        topPerformers: topPerformers,
        attendancePatterns: [],
        subjectPerformances: [],
        studentsNeedingSupport: [],
      );
    } catch (e) {
      return AnalyticsData(
        id: 'admin_analytics',
        statistics: {},
        performanceTrends: [],
        topPerformers: [],
        attendancePatterns: [],
        subjectPerformances: [],
        studentsNeedingSupport: [],
      );
    }
  }

  Future<List<TopPerformer>> _getTopPerformers() async {
    try {
      final submissionsQuery = await _firestore
          .collection('submissions')
          .where('score', isGreaterThan: 80)
          .orderBy('score', descending: true)
          .limit(5)
          .get();

      final performers = <TopPerformer>[];
      
      for (final doc in submissionsQuery.docs) {
        final data = doc.data();
        final studentDoc = await _firestore
            .collection('users')
            .doc(data['student_id'])
            .get();
        
        if (studentDoc.exists) {
          final studentData = studentDoc.data()!;
          performers.add(TopPerformer(
            studentId: data['student_id'],
            studentName: studentData['name'] ?? 'Unknown',
            assessment: data['assessment_title'] ?? 'Assessment',
            score: '${data['score']}%',
            subject: data['subject'] ?? 'General',
          ));
        }
      }
      
      return performers;
    } catch (e) {
      return [];
    }
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return 'Recently';
    
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is String) {
      date = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return 'Recently';
    }
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'No date';
    
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is String) {
      date = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return 'No date';
    }
    
    return '${date.day}/${date.month}/${date.year}';
  }
}