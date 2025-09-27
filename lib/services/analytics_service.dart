
import 'storage_service.dart';
import 'environment_service.dart';
import 'student_service.dart';
import 'attendance_service.dart';
import 'assessment_service.dart';

class AnalyticsService {
  static String get _collection => EnvironmentService.analyticsCollection;

  Future<String?> _getAuthToken() async {
    return await StorageService.getAuthToken();
  }

  // Get comprehensive analytics data
  Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      final studentService = StudentService();
      final attendanceService = AttendanceService();
      final assessmentService = AssessmentService();

      final studentStats = await studentService.getStudentStatistics();
      final attendanceStats = await attendanceService.getAttendanceStatistics();
      final assessmentStats = await assessmentService.getAssessmentStatistics();

      return {
        'totalStudents': int.tryParse(studentStats['totalStudents'] ?? '0') ?? 0,
        'averageAttendance': attendanceStats['overallAttendance'] ?? '0%',
        'completedAssessments': int.tryParse(assessmentStats['completedAssessments'] ?? '0') ?? 0,
        'averageGrade': 'N/A', // Calculate from actual grade data
        'studentGrowth': 0, // Calculate from historical data
        'attendanceChange': 0, // Calculate from historical data
        'assessmentGrowth': 0, // Calculate from historical data
        'gradeChange': '', // Calculate from historical data
      };
    } catch (e) {
      return {};
    }
  }

  // Get performance trends
  Future<List<Map<String, dynamic>>> getPerformanceTrends() async {
    try {
      // This would query historical performance data
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get top performers
  Future<List<Map<String, String>>> getTopPerformers() async {
    try {
      // This would query student performance data
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get weekly attendance patterns
  Future<List<Map<String, dynamic>>> getWeeklyAttendance() async {
    try {
      // This would query weekly attendance data
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get subject performance data
  Future<List<Map<String, dynamic>>> getSubjectPerformance() async {
    try {
      // This would query subject-wise performance data
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get students needing support
  Future<List<Map<String, String>>> getStudentsNeedingSupport() async {
    try {
      final studentService = StudentService();
      final studentsNeedingAttention = await studentService.getStudentsNeedingAttention();
      
      return studentsNeedingAttention.map((student) => {
        'name': student.name,
        'reason': student.status == 'HOLD' ? 'On Hold' : 'Low Attendance',
        'metric': student.attendance,
      }).toList();
    } catch (e) {
      return [];
    }
  }
}