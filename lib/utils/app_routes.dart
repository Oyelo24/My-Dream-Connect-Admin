import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/role_selector_screen.dart';
import '../screens/attendance_management_screen.dart';
import '../screens/student_management.dart';
import '../screens/assessment_management_screen.dart';
import '../screens/analytics_dashboard_screen.dart';
import '../screens/course_management_screen.dart';
import '../screens/teacher_management_screen.dart';
import '../screens/grade_management_screen.dart';
import '../screens/schedule_management_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/student_main_screen.dart';
class AppRoutes {
  static const String roleSelector = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String adminDashboard = '/admin-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String attendance = '/attendance';
  static const String students = '/students';
  static const String assessments = '/assessments';
  static const String analytics = '/analytics';
  static const String courses = '/courses';
  static const String teachers = '/teachers';
  static const String grades = '/grades';
  static const String schedule = '/schedule';
  static const String reports = '/reports';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      roleSelector: (context) => const RoleSelectorScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      adminDashboard: (context) => const AdminDashboard(),
      studentDashboard: (context) => const StudentMainScreen(),
      attendance: (context) => const AttendanceManagementScreen(),
      students: (context) => const StudentManagement(),
      assessments: (context) => const AssessmentManagementScreen(),
      analytics: (context) => const AnalyticsDashboardScreen(),
      courses: (context) => const CourseManagementScreen(),
      teachers: (context) => const TeacherManagementScreen(),
      grades: (context) => const GradeManagementScreen(),
      schedule: (context) => const ScheduleManagementScreen(),
      reports: (context) => const ReportsScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const RoleSelectorScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case '/admin-dashboard':
        return MaterialPageRoute(builder: (context) => const AdminDashboard());
      case '/student-dashboard':
        return MaterialPageRoute(builder: (context) => const StudentMainScreen());
      case '/attendance':
        return MaterialPageRoute(builder: (context) => const AttendanceManagementScreen());
      case '/students':
        return MaterialPageRoute(builder: (context) => const StudentManagement());
      case '/assessments':
        return MaterialPageRoute(builder: (context) => const AssessmentManagementScreen());
      case '/analytics':
        return MaterialPageRoute(builder: (context) => const AnalyticsDashboardScreen());
      case '/courses':
        return MaterialPageRoute(builder: (context) => const CourseManagementScreen());
      case '/teachers':
        return MaterialPageRoute(builder: (context) => const TeacherManagementScreen());
      case '/grades':
        return MaterialPageRoute(builder: (context) => const GradeManagementScreen());
      case '/schedule':
        return MaterialPageRoute(builder: (context) => const ScheduleManagementScreen());
      case '/reports':
        return MaterialPageRoute(builder: (context) => const ReportsScreen());
      case '/settings':
        return MaterialPageRoute(builder: (context) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}