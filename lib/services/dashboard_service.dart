import 'package:flutter/material.dart';
import 'package:mdc_admin/models/attendance.dart';
import 'student_service.dart';
import 'attendance_service.dart';
import 'assessment_service.dart';
import 'environment_service.dart';

class DashboardService {
  // Initialize services
  static final StudentService _studentService = StudentService();
  static final AttendanceService _attendanceService = AttendanceService();
  static final AssessmentService _assessmentService = AssessmentService();

  // Get app configuration from environment
  static Map<String, String> getAppConfig() {
    return {
      'appName': EnvironmentService.appName,
      'appSubtitle': EnvironmentService.appSubtitle,
      'initials': EnvironmentService.appInitials,
    };
  }

  // Get statistics data from real services
  static Future<Map<String, dynamic>> getStatistics() async {
    try {
      // Get real data from services
      final studentStats = await _studentService.getStudentStatistics();
      final attendanceStats = await _attendanceService
          .getAttendanceStatistics();
      final assessmentStats = await _assessmentService
          .getAssessmentStatistics();

      return {
        'totalStudents': {
          'value': studentStats['totalStudents'] ?? '0',
          'change': _calculateTrend(studentStats['totalStudents'] ?? '0'),
          'color': 0xFF4A90E2,
        },
        'activeStudents': {
          'value': studentStats['activeStudents'] ?? '0',
          'change': _calculateTrend(studentStats['activeStudents'] ?? '0'),
          'color': 0xFF4CAF50,
        },
        'totalAssessments': {
          'value': assessmentStats['totalAssessments'] ?? '0',
          'change': _calculateTrend(assessmentStats['totalAssessments'] ?? '0'),
          'color': 0xFFFF9800,
        },
        'attendanceRate': {
          'value': attendanceStats['overallAttendance'] ?? '0%',
          'change': _calculateTrend(attendanceStats['overallAttendance'] ?? '0%'),
          'color': 0xFF2C3E50,
        },
      };
    } catch (e) {
      print('Error fetching statistics: $e');
      // Return default values if services fail
      return {
        'totalStudents': {'value': '0', 'change': '', 'color': 0xFF4A90E2},
        'activeStudents': {'value': '0', 'change': '', 'color': 0xFF4CAF50},
        'totalAssessments': {'value': '0', 'change': '', 'color': 0xFFFF9800},
        'attendanceRate': {'value': '0%', 'change': '', 'color': 0xFF2C3E50},
      };
    }
  }

  // Get recent activities from real data
  static Future<List<Map<String, String>>> getRecentActivities() async {
    try {
      // Get recent students and attendance data
      final students = await _studentService.getAllStudents();
      final attendance = await _attendanceService.getAllAttendanceRecords();

      List<Map<String, String>> activities = [];

      // Add recent student enrollments
      final recentStudents = students.take(3).toList();
      for (var student in recentStudents) {
        activities.add({
          'name': student.name,
          'action': 'enrolled in program',
          'time': _getRelativeTime(student.enrollmentDate),
          'score': student.grade != 'N/A' ? student.grade : '',
        });
      }

      // Add recent attendance records
      final recentAttendance = attendance.take(2).toList();
      for (var record in recentAttendance) {
        activities.add({
          'name': record.studentName,
          'action': 'checked in for ${record.session}',
          'time': _getRelativeTime(record.date),
          'score': record.status.displayName,
        });
      }

      return activities;
    } catch (e) {
      print('Error fetching recent activities: $e');
      return [];
    }
  }

  // Get urgent tasks based on real data
  static Future<List<Map<String, String>>> getUrgentTasks() async {
    try {
      // Get students needing attention
      final studentsNeedingAttention = await _studentService
          .getStudentsNeedingAttention();
      final students = await _studentService.getAllStudents();

      List<Map<String, String>> tasks = [];

      // Add students with low attendance
      for (var student in studentsNeedingAttention) {
        tasks.add({
          'task':
              'Review ${student.name} - Low attendance (${student.attendance})',
          'priority': 'HIGH',
        });
      }

      // Add students with poor grades
      final poorPerformers = students
          .where(
            (s) =>
                s.grade != 'N/A' &&
                double.tryParse(s.grade.replaceAll('%', '')) != null &&
                double.parse(s.grade.replaceAll('%', '')) < 60,
          )
          .take(2);
      for (var student in poorPerformers) {
        tasks.add({
          'task':
              'Schedule meeting with ${student.name} - Poor performance (${student.grade})',
          'priority': 'MEDIUM',
        });
      }

      return tasks;
    } catch (e) {
      print('Error fetching urgent tasks: $e');
      return [];
    }
  }

  // Get upcoming assessments from real data
  static Future<List<Map<String, String>>> getUpcomingAssessments() async {
    try {
      final assessments = await _assessmentService.getAllAssessments();

      // Get scheduled assessments
      final upcomingAssessments = assessments
          .where((a) => a.isScheduled)
          .take(3)
          .toList();

      return upcomingAssessments.map((assessment) {
        return {
          'title': assessment.title,
          'date': _getScheduledDate(assessment.createdDate),
          'students': '${assessment.totalStudents} students',
        };
      }).toList();
    } catch (e) {
      print('Error fetching upcoming assessments: $e');
      return [];
    }
  }

  // Get assessment progress from real data
  static Future<Map<String, dynamic>> getAssessmentProgress() async {
    try {
      final assessmentStats = await _assessmentService
          .getAssessmentStatistics();

      return {
        'completed':
            '${assessmentStats['completedAssessments']}/${assessmentStats['totalAssessments']}',
        'percentage': assessmentStats['averageCompletion'] != null
            ? double.tryParse(
                    assessmentStats['averageCompletion'].replaceAll('%', ''),
                  ) ??
                  0.0
            : 0.0,
        'averageGrade': _calculateAverageGrade(assessmentStats)
      };
    } catch (e) {
      print('Error fetching assessment progress: $e');
      return {'completed': '0/0', 'percentage': 0.0, 'averageGrade': 'N/A'};
    }
  }

  // Get menu items
  static List<String> getMenuItems() {
    return ['Dashboard', 'Students', 'Attendance', 'Assessments', 'Analytics', 'Tracks', 'Instructors', 'Settings'];
  }

  // Get menu icons
  static IconData getMenuIcon(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.people;
      case 2:
        return Icons.calendar_today;
      case 3:
        return Icons.assignment;
      case 4:
        return Icons.analytics;
      case 5:
        return Icons.track_changes;
      case 6:
        return Icons.school;
      case 7:
        return Icons.settings;
      default:
        return Icons.dashboard;
    }
  }

  // Get page titles
  static String getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard Overview';
      case 1:
        return 'Student Management';
      case 2:
        return 'Attendance Management';
      case 3:
        return 'Assessments Management';
      case 4:
        return 'Analytics';
      case 5:
        return 'Track Management';
      case 6:
        return 'Instructor Management';
      case 7:
        return 'Settings';
      default:
        return 'Dashboard Overview';
    }
  }

  // Get page subtitles
  static String getPageSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Monitor your tech cohort performance and manage student progress';
      case 1:
        return 'View and manage all enrolled students';
      case 2:
        return 'Track and manage student attendance records';
      case 3:
        return 'Create and manage student assessments';
      case 4:
        return 'View detailed analytics and reports';
      case 5:
        return 'Manage tech tracks and curriculum';
      case 6:
        return 'Manage instructors and assignments';
      case 7:
        return 'Configure system settings and preferences';
      default:
        return 'Monitor your tech cohort performance and manage student progress';
    }
  }

  // Get theme colors
  static Map<String, Color> getThemeColors() {
    return {
      'primary': const Color(0xFF4A90E2),
      'secondary': const Color(0xFF2C3E50),
      'success': const Color(0xFF4CAF50),
      'warning': const Color(0xFFFF9800),
      'danger': const Color(0xFFF44336),
    };
  }

  // Helper method to calculate trend (placeholder for now)
  static String _calculateTrend(String currentValue) {
    // In a real implementation, this would compare with historical data
    // For now, return empty string to indicate no trend data
    return '';
  }

  // Helper method to get relative time
  static String _getRelativeTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  // Helper method to calculate average grade
  static String _calculateAverageGrade(Map<String, dynamic> assessmentStats) {
    // In a real implementation, this would calculate from actual grade data
    // For now, return N/A to indicate no grade data available
    return 'N/A';
  }

  // Helper method to get scheduled date
  static String _getScheduledDate(String createdDate) {
    try {
      final created = DateTime.parse(createdDate);
      final scheduled = created.add(const Duration(days: 7));
      final now = DateTime.now();
      final difference = scheduled.difference(now);

      if (difference.inDays > 0) {
        return 'In ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
      } else if (difference.inDays == 0) {
        return 'Today';
      } else {
        return 'Overdue';
      }
    } catch (e) {
      return 'TBD';
    }
  }
}
