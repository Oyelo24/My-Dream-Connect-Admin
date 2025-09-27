import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mdc_admin/models/attendance.dart';
import 'package:mdc_admin/services/config_service.dart';
import 'package:mdc_admin/services/storage_service.dart';

class AttendanceService {
  // Collection name for attendance
  static const String _collection = 'attendance';

  // Get auth token
  Future<String?> _getAuthToken() async {
    return await StorageService.getAuthToken();
  }

  // Get all attendance records
  Future<List<AttendanceRecord>> getAllAttendanceRecords() async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records
            .map((record) => AttendanceRecord.fromJson(record))
            .toList();
      } else {
        print('Error fetching attendance records: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching attendance records: $e');
      return [];
    }
  }

  // Get attendance records by date
  Future<List<AttendanceRecord>> getAttendanceByDate(String date) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=date="$date"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records
            .map((record) => AttendanceRecord.fromJson(record))
            .toList();
      } else {
        print('Error fetching attendance by date: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching attendance by date: $e');
      return [];
    }
  }

  // Get attendance records by student
  Future<List<AttendanceRecord>> getAttendanceByStudent(
    String studentId,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=studentId="$studentId"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records
            .map((record) => AttendanceRecord.fromJson(record))
            .toList();
      } else {
        print('Error fetching attendance by student: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching attendance by student: $e');
      return [];
    }
  }

  // Get attendance records by session
  Future<List<AttendanceRecord>> getAttendanceBySession(String session) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=session="$session"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records
            .map((record) => AttendanceRecord.fromJson(record))
            .toList();
      } else {
        print('Error fetching attendance by session: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching attendance by session: $e');
      return [];
    }
  }

  // Create attendance record
  Future<AttendanceRecord?> createAttendanceRecord({
    required String studentId,
    required String studentName,
    required String studentEmail,
    required String session,
    required String checkInTime,
    required AttendanceStatus status,
    String? notes,
    required String date,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final data = {
        'studentId': studentId,
        'studentName': studentName,
        'studentEmail': studentEmail,
        'session': session,
        'checkInTime': checkInTime,
        'status': status.name,
        'notes': notes ?? '',
        'date': date,
      };

      final response = await http.post(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final record = jsonDecode(response.body);
        return AttendanceRecord.fromJson(record);
      } else {
        print('Error creating attendance record: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating attendance record: $e');
      return null;
    }
  }

  // Update attendance record
  Future<AttendanceRecord?> updateAttendanceRecord(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final record = jsonDecode(response.body);
        return AttendanceRecord.fromJson(record);
      } else {
        print('Error updating attendance record: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating attendance record: $e');
      return null;
    }
  }

  // Delete attendance record
  Future<bool> deleteAttendanceRecord(String id) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Error deleting attendance record: $e');
      return false;
    }
  }

  // Get attendance statistics
  Future<Map<String, dynamic>> getAttendanceStatistics() async {
    try {
      final records = await getAllAttendanceRecords();

      final totalRecords = records.length;
      final presentCount = records.where((r) => r.isPresent).length;
      final lateCount = records.where((r) => r.isLate).length;
      final absentCount = records.where((r) => r.isAbsent).length;
      final excusedCount = records.where((r) => r.isExcused).length;

      final presentPercentage = totalRecords > 0
          ? (presentCount / totalRecords * 100).toStringAsFixed(1)
          : '0.0';
      final latePercentage = totalRecords > 0
          ? (lateCount / totalRecords * 100).toStringAsFixed(1)
          : '0.0';
      final absentPercentage = totalRecords > 0
          ? (absentCount / totalRecords * 100).toStringAsFixed(1)
          : '0.0';

      return {
        'totalRecords': totalRecords.toString(),
        'presentCount': presentCount.toString(),
        'lateCount': lateCount.toString(),
        'absentCount': absentCount.toString(),
        'excusedCount': excusedCount.toString(),
        'presentPercentage': '$presentPercentage%',
        'latePercentage': '$latePercentage%',
        'absentPercentage': '$absentPercentage%',
        'overallAttendance': '$presentPercentage%',
      };
    } catch (e) {
      print('Error getting attendance statistics: $e');
      return {
        'totalRecords': '0',
        'presentCount': '0',
        'lateCount': '0',
        'absentCount': '0',
        'excusedCount': '0',
        'presentPercentage': '0.0%',
        'latePercentage': '0.0%',
        'absentPercentage': '0.0%',
        'overallAttendance': '0.0%',
      };
    }
  }

  // Get today's attendance
  Future<List<AttendanceRecord>> getTodayAttendance() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return getAttendanceByDate(today);
  }

  // Mark student present
  Future<bool> markPresent(
    String studentId,
    String studentName,
    String studentEmail,
    String session,
  ) async {
    final now = DateTime.now();
    final checkInTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final date = now.toIso8601String().split('T')[0];

    final record = await createAttendanceRecord(
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      session: session,
      checkInTime: checkInTime,
      status: AttendanceStatus.present,
      date: date,
    );

    return record != null;
  }

  // Mark student absent
  Future<bool> markAbsent(
    String studentId,
    String studentName,
    String studentEmail,
    String session,
  ) async {
    final now = DateTime.now();
    final date = now.toIso8601String().split('T')[0];

    final record = await createAttendanceRecord(
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      session: session,
      checkInTime: '--:--',
      status: AttendanceStatus.absent,
      date: date,
    );

    return record != null;
  }

  // Mark student late
  Future<bool> markLate(
    String studentId,
    String studentName,
    String studentEmail,
    String session,
  ) async {
    final now = DateTime.now();
    final checkInTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final date = now.toIso8601String().split('T')[0];

    final record = await createAttendanceRecord(
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      session: session,
      checkInTime: checkInTime,
      status: AttendanceStatus.late,
      date: date,
    );

    return record != null;
  }
}
