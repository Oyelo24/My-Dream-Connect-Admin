import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mdc_admin/models/student.dart';
import 'package:mdc_admin/services/config_service.dart';
import 'package:mdc_admin/services/storage_service.dart';
import 'package:mdc_admin/services/environment_service.dart';
import 'package:mdc_admin/services/id_generator_service.dart';

class StudentService {
  // Collection name for students
  static String get _collection => EnvironmentService.userCollection;

  // Get auth token
  Future<String?> _getAuthToken() async {
    return await StorageService.getAuthToken();
  }

  // Get all students
  Future<List<Student>> getAllStudents() async {
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
        return records.map((record) => Student.fromJson(record)).toList();
      } else {
        print('Error fetching students: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }

  // Get student by ID
  Future<Student?> getStudentById(String id) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Student.fromJson(data);
      } else {
        print('Error fetching student: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching student: $e');
      return null;
    }
  }

  // Search students
  Future<List<Student>> searchStudents(String query) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=name~"$query"||email~"$query"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records.map((record) => Student.fromJson(record)).toList();
      } else {
        print('Error searching students: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error searching students: $e');
      return [];
    }
  }

  // Create new student
  Future<Student?> createStudent({
    required String name,
    required String email,
    required String phone,
    String? enrollmentDate,
    String? status,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final studentId = IdGeneratorService.generateStudentId();
      final data = {
        'id': studentId,
        'name': name,
        'email': email,
        'phone': phone,
        'enrollmentDate': enrollmentDate ?? DateTime.now().toIso8601String(),
        'status': status ?? 'ACTIVE',
        'attendance': '0%',
        'grade': 'N/A',
        'progress': '0/0',
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
        return Student.fromJson(record);
      } else {
        print('Error creating student: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating student: $e');
      return null;
    }
  }

  // Update student
  Future<Student?> updateStudent(String id, Map<String, dynamic> data) async {
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
        return Student.fromJson(record);
      } else {
        print('Error updating student: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating student: $e');
      return null;
    }
  }

  // Delete student
  Future<bool> deleteStudent(String id) async {
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
      print('Error deleting student: $e');
      return false;
    }
  }

  // Get students by status
  Future<List<Student>> getStudentsByStatus(String status) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=status="$status"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records.map((record) => Student.fromJson(record)).toList();
      } else {
        print('Error fetching students by status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching students by status: $e');
      return [];
    }
  }

  // Get students needing attention
  Future<List<Student>> getStudentsNeedingAttention() async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=status="HOLD"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records.map((record) => Student.fromJson(record)).toList();
      } else {
        print(
          'Error fetching students needing attention: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      print('Error fetching students needing attention: $e');
      return [];
    }
  }

  // Update student attendance
  Future<bool> updateStudentAttendance(
    String studentId,
    String attendance,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$studentId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'attendance': attendance}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating student attendance: $e');
      return false;
    }
  }

  // Update student grade
  Future<bool> updateStudentGrade(String studentId, String grade) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$studentId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'grade': grade}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating student grade: $e');
      return false;
    }
  }

  // Update student status
  Future<bool> updateStudentStatus(String studentId, String status) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$studentId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating student status: $e');
      return false;
    }
  }

  // Get student statistics
  Future<Map<String, dynamic>> getStudentStatistics() async {
    try {
      final allStudents = await getAllStudents();

      final totalStudents = allStudents.length;
      final activeStudents = allStudents.where((s) => s.isActive).length;
      final studentsNeedingAttention = allStudents
          .where((s) => s.needsAttention)
          .length;

      return {
        'totalStudents': totalStudents.toString(),
        'activeStudents': activeStudents.toString(),
        'studentsNeedingAttention': studentsNeedingAttention.toString(),
        'inactiveStudents': (totalStudents - activeStudents).toString(),
      };
    } catch (e) {
      print('Error getting student statistics: $e');
      return {
        'totalStudents': '0',
        'activeStudents': '0',
        'studentsNeedingAttention': '0',
        'inactiveStudents': '0',
      };
    }
  }
}
