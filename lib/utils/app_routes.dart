import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/attendance_management_screen.dart';
import '../screens/student_management.dart';
import '../screens/assessment_management_screen.dart';
import '../screens/analytics_dashboard_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String attendance = '/attendance';
  static const String students = '/students';
  static const String assessments = '/assessments';
  static const String analytics = '/analytics';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      dashboard: (context) => const AdminDashboard(),
      attendance: (context) => const AttendanceManagementScreen(),
      students: (context) => const StudentManagement(),
      assessments: (context) => const AssessmentManagementScreen(),
      analytics: (context) => const AnalyticsDashboardScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case dashboard:
        return MaterialPageRoute(builder: (context) => const AdminDashboard());
      case attendance:
        return MaterialPageRoute(builder: (context) => const AttendanceManagementScreen());
      case students:
        return MaterialPageRoute(builder: (context) => const StudentManagement());
      case assessments:
        return MaterialPageRoute(builder: (context) => const AssessmentManagementScreen());
      case analytics:
        return MaterialPageRoute(builder: (context) => const AnalyticsDashboardScreen());
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