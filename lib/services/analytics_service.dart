import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mdc_admin/models/analytics.dart';
import 'package:mdc_admin/services/config_service.dart';
import 'package:mdc_admin/services/storage_service.dart';

class AnalyticsService {
  // Collection name for analytics
  static const String _collection = 'analytics';

  // Get auth token
  Future<String?> _getAuthToken() async {
    return await StorageService.getAuthToken();
  }

  // Get analytics data
  Future<AnalyticsData?> getAnalyticsData() async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${ConfigService.baseUrl}/api/collections/$_collection/records'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['items'] as List<dynamic>;

        if (records.isNotEmpty) {
          return AnalyticsData.fromJson(records.first);
        } else {
          // Return empty analytics data if no records exist
          return AnalyticsData(
            id: '',
            statistics: {},
            performanceTrends: [],
            topPerformers: [],
            attendancePatterns: [],
            subjectPerformances: [],
            studentsNeedingSupport: [],
          );
        }
      } else {
        print('Error fetching analytics data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching analytics data: $e');
      return null;
    }
  }

  // Create or update analytics data
  Future<AnalyticsData?> saveAnalyticsData(AnalyticsData analytics) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return null;

      final data = analytics.toJson();

      http.Response response;
      if (analytics.id.isEmpty) {
        // Create new record
        response = await http.post(
          Uri.parse('${ConfigService.baseUrl}/api/collections/$_collection/records'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );
      } else {
        // Update existing record
        response = await http.patch(
          Uri.parse('${ConfigService.baseUrl}/api/collections/$_collection/records/${analytics.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );
      }

      if (response.statusCode == 200) {
        final record = jsonDecode(response.body);
        return AnalyticsData.fromJson(record);
      } else {
        print('Error saving analytics data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saving analytics data: $e');
      return null;
    }
  }

  // Get performance trends
  Future<List<PerformanceTrend>> getPerformanceTrends() async {
    try {
      final analytics = await getAnalyticsData();
      return analytics?.performanceTrends ?? [];
    } catch (e) {
      print('Error fetching performance trends: $e');
      return [];
    }
  }

  // Get top performers
  Future<List<TopPerformer>> getTopPerformers() async {
    try {
      final analytics = await getAnalyticsData();
      return analytics?.topPerformers ?? [];
    } catch (e) {
      print('Error fetching top performers: $e');
      return [];
    }
  }

  // Get attendance patterns
  Future<List<AttendancePattern>> getAttendancePatterns() async {
    try {
      final analytics = await getAnalyticsData();
      return analytics?.attendancePatterns ?? [];
    } catch (e) {
      print('Error fetching attendance patterns: $e');
      return [];
    }
  }

  // Get subject performances
  Future<List<SubjectPerformance>> getSubjectPerformances() async {
    try {
      final analytics = await getAnalyticsData();
      return analytics?.subjectPerformances ?? [];
    } catch (e) {
      print('Error fetching subject performances: $e');
      return [];
    }
  }

  // Get students needing support
  Future<List<StudentNeedingSupport>> getStudentsNeedingSupport() async {
    try {
      final analytics = await getAnalyticsData();
      return analytics?.studentsNeedingSupport ?? [];
    } catch (e) {
      print('Error fetching students needing support: $e');
      return [];
    }
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final analytics = await getAnalyticsData();
      return analytics?.statistics ?? {};
    } catch (e) {
      print('Error fetching statistics: $e');
      return {};
    }
  }

  // Generate analytics from current data
  Future<AnalyticsData> generateAnalytics() async {
    try {
      // This would typically aggregate data from students, attendance, and assessments
      // For now, return a basic analytics structure
      return AnalyticsData(
        id: '',
        statistics: {
          'totalStudents': '0',
          'activeStudents': '0',
          'overallAttendance': '0%',
          'averagePerformance': '0%',
          'assessmentsCompleted': '0',
          'studentsNeedingSupport': '0',
        },
        performanceTrends: [
          PerformanceTrend(
            month: 'Jan',
            metric: 'performance',
            value: 85.0,
            label: 'January Performance',
          ),
          PerformanceTrend(
            month: 'Feb',
            metric: 'performance',
            value: 88.0,
            label: 'February Performance',
          ),
          PerformanceTrend(
            month: 'Mar',
            metric: 'performance',
            value: 92.0,
            label: 'March Performance',
          ),
        ],
        topPerformers: [
          TopPerformer(
            studentId: '1',
            studentName: 'Alice Johnson',
            assessment: 'Math Quiz 1',
            score: '95%',
            subject: 'Mathematics',
          ),
          TopPerformer(
            studentId: '2',
            studentName: 'Bob Smith',
            assessment: 'Science Test',
            score: '93%',
            subject: 'Science',
          ),
        ],
        attendancePatterns: [
          AttendancePattern(day: 'Mon', value: 92.0, count: 25),
          AttendancePattern(day: 'Tue', value: 88.0, count: 23),
          AttendancePattern(day: 'Wed', value: 95.0, count: 26),
          AttendancePattern(day: 'Thu', value: 90.0, count: 24),
          AttendancePattern(day: 'Fri', value: 87.0, count: 22),
        ],
        subjectPerformances: [
          SubjectPerformance(
            subject: 'Mathematics',
            value: 88.0,
            percentage: '88%',
            averageScore: 88,
          ),
          SubjectPerformance(
            subject: 'Science',
            value: 85.0,
            percentage: '85%',
            averageScore: 85,
          ),
          SubjectPerformance(
            subject: 'English',
            value: 82.0,
            percentage: '82%',
            averageScore: 82,
          ),
        ],
        studentsNeedingSupport: [
          StudentNeedingSupport(
            studentId: '3',
            studentName: 'Charlie Brown',
            issue: 'Low attendance',
            priority: 'HIGH',
            status: 'ACTIVE',
          ),
          StudentNeedingSupport(
            studentId: '4',
            studentName: 'Diana Prince',
            issue: 'Poor performance',
            priority: 'MEDIUM',
            status: 'ACTIVE',
          ),
        ],
      );
    } catch (e) {
      print('Error generating analytics: $e');
      return AnalyticsData(
        id: '',
        statistics: {},
        performanceTrends: [],
        topPerformers: [],
        attendancePatterns: [],
        subjectPerformances: [],
        studentsNeedingSupport: [],
      );
    }
  }

  // Update analytics data
  Future<bool> updateAnalytics(AnalyticsData analytics) async {
    try {
      final result = await saveAnalyticsData(analytics);
      return result != null;
    } catch (e) {
      print('Error updating analytics: $e');
      return false;
    }
  }
}
