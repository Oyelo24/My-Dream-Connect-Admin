import 'package:cloud_firestore/cloud_firestore.dart';


class AdminAttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getAttendanceStats() async {
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final attendanceQuery = await _firestore
          .collection('attendance')
          .where('date', isEqualTo: todayStr)
          .get();

      final totalStudentsQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      final totalStudents = totalStudentsQuery.docs.length;
      final presentCount = attendanceQuery.docs.where((doc) => doc.data()['status'] == 'Present').length;
      final lateCount = attendanceQuery.docs.where((doc) => doc.data()['status'] == 'Late').length;
      final absentCount = totalStudents - presentCount - lateCount;
      final attendanceRate = totalStudents > 0 ? ((presentCount + lateCount) / totalStudents * 100) : 0.0;

      return {
        'totalStudents': totalStudents,
        'presentCount': presentCount,
        'lateCount': lateCount,
        'absentCount': absentCount,
        'attendanceRate': attendanceRate,
      };
    } catch (e) {
      return {
        'totalStudents': 0,
        'presentCount': 0,
        'lateCount': 0,
        'absentCount': 0,
        'attendanceRate': 0.0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getTodayAttendance() async {
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final studentsQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      final attendanceQuery = await _firestore
          .collection('attendance')
          .where('date', isEqualTo: todayStr)
          .get();

      final attendanceMap = <String, Map<String, dynamic>>{};
      for (final doc in attendanceQuery.docs) {
        final data = doc.data();
        attendanceMap[data['student_id']] = {
          'status': data['status'],
          'checkInTime': data['check_in_time'],
          'id': doc.id,
        };
      }

      final attendanceList = <Map<String, dynamic>>[];
      for (final studentDoc in studentsQuery.docs) {
        final studentData = studentDoc.data();
        final attendance = attendanceMap[studentDoc.id];
        
        attendanceList.add({
          'studentId': studentDoc.id,
          'studentName': studentData['name'] ?? 'Unknown',
          'studentEmail': studentData['email'] ?? '',
          'status': attendance?['status'] ?? 'Absent',
          'checkInTime': attendance?['checkInTime'] != null 
              ? _formatTime(attendance!['checkInTime']) 
              : '--',
          'attendanceId': attendance?['id'],
          'engagement': (studentData['engagement_score'] ?? 0.7).toDouble(),
        });
      }

      return attendanceList;
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateAttendance(String studentId, String status) async {
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final existingQuery = await _firestore
          .collection('attendance')
          .where('student_id', isEqualTo: studentId)
          .where('date', isEqualTo: todayStr)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        await existingQuery.docs.first.reference.update({
          'status': status,
          'check_in_time': status != 'Absent' ? DateTime.now().toIso8601String() : null,
          'updated_at': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.collection('attendance').add({
          'student_id': studentId,
          'status': status,
          'date': todayStr,
          'check_in_time': status != 'Absent' ? DateTime.now().toIso8601String() : null,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> startSession(String title, String topic) async {
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      print('Admin creating session with date: $todayStr');
      
      // Close any existing active sessions
      final existingSessions = await _firestore
          .collection('sessions')
          .where('is_active', isEqualTo: true)
          .get();
      
      for (final doc in existingSessions.docs) {
        await doc.reference.update({'is_active': false});
      }
      
      final sessionData = {
        'title': title,
        'topic': topic,
        'date': todayStr,
        'start_time': DateTime.now().toIso8601String(),
        'is_active': true,
        'created_at': FieldValue.serverTimestamp(),
      };
      
      print('Creating session with data: $sessionData');
      
      await _firestore.collection('sessions').add(sessionData);
      
      print('Session created successfully');
      return true;
    } catch (e) {
      print('Error creating session: $e');
      return false;
    }
  }

  Future<bool> closeSession() async {
    try {
      final activeSessions = await _firestore
          .collection('sessions')
          .where('is_active', isEqualTo: true)
          .get();
      
      for (final doc in activeSessions.docs) {
        await doc.reference.update({
          'is_active': false,
          'end_time': DateTime.now().toIso8601String(),
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isSessionActive() async {
    try {
      final activeSessions = await _firestore
          .collection('sessions')
          .where('is_active', isEqualTo: true)
          .get();
      
      return activeSessions.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  String _formatTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return '--';
    }
  }
}