import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mdc_admin/models/assessment.dart';
import 'package:mdc_admin/services/config_service.dart';
import 'package:mdc_admin/services/storage_service.dart';

class AssessmentService {
  // Collection name for assessments
  static const String _collection = 'assessments';

  // Get auth token
  Future<String?> _getAuthToken() async {
    return await StorageService.getAuthToken();
  }

  // Get all assessments
  Future<List<Assessment>> getAllAssessments() async {
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
        return records.map((record) => Assessment.fromJson(record)).toList();
      } else {
        print('Error fetching assessments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching assessments: $e');
      return [];
    }
  }

  // Get assessment by ID
  Future<Assessment?> getAssessmentById(String id) async {
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
        return Assessment.fromJson(data);
      } else {
        print('Error fetching assessment: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching assessment: $e');
      return null;
    }
  }

  // Get assessments by status
  Future<List<Assessment>> getAssessmentsByStatus(
    AssessmentStatus status,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=status="${status.name}"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        return records.map((record) => Assessment.fromJson(record)).toList();
      } else {
        print('Error fetching assessments by status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching assessments by status: $e');
      return [];
    }
  }

  // Get active assessments
  Future<List<Assessment>> getActiveAssessments() async {
    return getAssessmentsByStatus(AssessmentStatus.active);
  }

  // Get completed assessments
  Future<List<Assessment>> getCompletedAssessments() async {
    return getAssessmentsByStatus(AssessmentStatus.completed);
  }

  // Get scheduled assessments
  Future<List<Assessment>> getScheduledAssessments() async {
    return getAssessmentsByStatus(AssessmentStatus.scheduled);
  }

  // Create new assessment
  Future<Assessment?> createAssessment({
    required String title,
    required String subject,
    required String duration,
    required String questions,
    String? description,
    AssessmentStatus status = AssessmentStatus.draft,
  }) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final data = {
        'title': title,
        'subject': subject,
        'duration': duration,
        'questions': questions,
        'description': description ?? '',
        'status': status.name,
        'completion': '0/0',
        'performance': '',
        'createdDate': DateTime.now().toIso8601String(),
        'totalQuestions': 0,
        'totalStudents': 0,
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
        return Assessment.fromJson(record);
      } else {
        print('Error creating assessment: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error creating assessment: $e');
      return null;
    }
  }

  // Update assessment
  Future<Assessment?> updateAssessment(
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
        return Assessment.fromJson(record);
      } else {
        print('Error updating assessment: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error updating assessment: $e');
      return null;
    }
  }

  // Delete assessment
  Future<bool> deleteAssessment(String id) async {
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
      print('Error deleting assessment: $e');
      return false;
    }
  }

  // Update assessment status
  Future<bool> updateAssessmentStatus(
    String id,
    AssessmentStatus status,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status.name}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating assessment status: $e');
      return false;
    }
  }

  // Update assessment completion
  Future<bool> updateAssessmentCompletion(String id, String completion) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'completion': completion}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating assessment completion: $e');
      return false;
    }
  }

  // Update assessment performance
  Future<bool> updateAssessmentPerformance(
    String id,
    String performance,
  ) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      final response = await http.patch(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'performance': performance}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating assessment performance: $e');
      return false;
    }
  }

  // Get assessment statistics
  Future<Map<String, dynamic>> getAssessmentStatistics() async {
    try {
      final assessments = await getAllAssessments();

      final totalAssessments = assessments.length;
      final activeAssessments = assessments.where((a) => a.isActive).length;
      final completedAssessments = assessments
          .where((a) => a.isCompleted)
          .length;
      final scheduledAssessments = assessments
          .where((a) => a.isScheduled)
          .length;

      final totalCompletion = assessments.fold<double>(
        0.0,
        (sum, a) => sum + a.completionPercentage,
      );
      final averageCompletion = totalAssessments > 0
          ? totalCompletion / totalAssessments
          : 0.0;

      return {
        'totalAssessments': totalAssessments.toString(),
        'activeAssessments': activeAssessments.toString(),
        'completedAssessments': completedAssessments.toString(),
        'scheduledAssessments': scheduledAssessments.toString(),
        'averageCompletion': '${averageCompletion.toStringAsFixed(1)}%',
        'draftAssessments': assessments
            .where((a) => a.isDraft)
            .length
            .toString(),
      };
    } catch (e) {
      print('Error getting assessment statistics: $e');
      return {
        'totalAssessments': '0',
        'activeAssessments': '0',
        'completedAssessments': '0',
        'scheduledAssessments': '0',
        'averageCompletion': '0.0%',
        'draftAssessments': '0',
      };
    }
  }

  // Get upcoming assessments (next 7 days)
  Future<List<Assessment>> getUpcomingAssessments() async {
    try {
      final token = await _getAuthToken();
      if (token == null) return [];

      final now = DateTime.now();
      final nextWeek = now.add(const Duration(days: 7));

      final response = await http.get(
        Uri.parse(
          '${ConfigService.baseUrl}/api/collections/$_collection/records?filter=status="scheduled"',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;
        final assessments = records
            .map((record) => Assessment.fromJson(record))
            .toList();

        // Filter assessments that are scheduled within the next week
        return assessments.where((assessment) {
          // This would require additional date filtering logic
          // For now, return all scheduled assessments
          return assessment.isScheduled;
        }).toList();
      } else {
        print('Error fetching upcoming assessments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching upcoming assessments: $e');
      return [];
    }
  }
}
