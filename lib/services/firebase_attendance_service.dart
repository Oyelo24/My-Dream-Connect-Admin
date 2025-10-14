import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_attendance.dart';

class FirebaseAttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StudentAttendanceSummary> getStudentAttendance(String studentId) async {
    try {
      // Get attendance records
      final attendanceQuery = await _firestore
          .collection('attendance')
          .where('student_id', isEqualTo: studentId)
          .orderBy('date', descending: true)
          .get();

      final records = attendanceQuery.docs.map((doc) {
        final data = doc.data();
        return StudentAttendanceRecord(
          id: doc.id,
          sessionTitle: data['session_title'] ?? '',
          date: data['date'] ?? '',
          status: data['status'] ?? 'Absent',
          checkInTime: data['check_in_time'],
        );
      }).toList();

      // Calculate stats
      final presentCount = records.where((r) => r.status == 'Present').length;
      final lateCount = records.where((r) => r.status == 'Late').length;
      final absentCount = records.where((r) => r.status == 'Absent').length;
      final attendanceRate = records.isNotEmpty ? (presentCount + lateCount) / records.length : 0.0;

      // Get today's session
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final todaySession = await _getTodaySession(todayStr);

      return StudentAttendanceSummary(
        attendanceRate: attendanceRate,
        presentCount: presentCount,
        lateCount: lateCount,
        absentCount: absentCount,
        todaySession: todaySession,
        recentRecords: records.take(5).toList(),
      );
    } catch (e) {
      print('Error: $e');
      return StudentAttendanceSummary(
        attendanceRate: 0.0,
        presentCount: 0,
        lateCount: 0,
        absentCount: 0,
        todaySession: null,
        recentRecords: [],
      );
    }
  }

  Future<StudentAttendanceRecord?> _getTodaySession(String date) async {
    try {
      // Use the same logic as AdminAttendanceService.isSessionActive()
      final activeSessions = await _firestore
          .collection('sessions')
          .where('is_active', isEqualTo: true)
          .get();
      
      print('Found ${activeSessions.docs.length} active sessions total');
      
      // Filter by today's date
      for (final doc in activeSessions.docs) {
        final data = doc.data();
        print('Session: ${data['title']}, date: ${data['date']}, active: ${data['is_active']}');
        
        if (data['date'] == date) {
          print('Found matching session for today!');
          final startTime = data['start_time'] != null ? _formatTime(data['start_time']) : '';
          final endTime = data['end_time'] != null ? _formatTime(data['end_time']) : 'Ongoing';
          
          return StudentAttendanceRecord(
            id: doc.id,
            sessionTitle: data['title'] ?? 'Today\'s Session',
            date: '$date • $startTime - $endTime',
            status: 'Pending',
          );
        }
      }
      
      print('No active session found for date: $date');
      return null;
    } catch (e) {
      print('Error getting today session: $e');
      return null;
    }
  }

  Future<bool> markAttendance(String sessionId, String studentId, String status) async {
    try {
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      // Check if attendance already marked for today
      final existingQuery = await _firestore
          .collection('attendance')
          .where('student_id', isEqualTo: studentId)
          .where('date', isEqualTo: todayStr)
          .get();
      
      if (existingQuery.docs.isNotEmpty) {
        // Update existing attendance
        await existingQuery.docs.first.reference.update({
          'status': status,
          'check_in_time': DateTime.now().toIso8601String(),
          'session_id': sessionId,
          'updated_at': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new attendance record
        await _firestore.collection('attendance').add({
          'student_id': studentId,
          'session_id': sessionId,
          'status': status,
          'date': todayStr,
          'check_in_time': DateTime.now().toIso8601String(),
          'session_title': 'Today\'s Session',
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      return true;
    } catch (e) {
      print('Error marking attendance: $e');
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