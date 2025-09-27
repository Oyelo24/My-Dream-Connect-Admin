import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_dashboard_viewmodel.dart';
import '../utils/app_colors.dart';
import 'student_dashboard_screen.dart';
import 'student_courses_screen.dart';
import 'student_assessments_screen.dart';
import 'student_attendance_screen.dart';
import 'student_reports_screen.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    'Dashboard',
    'My Courses',
    'Assessments',
    'Reports',
    'Attendance',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: Text(_menuItems[_selectedIndex]),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                SizedBox(height: 10),
                Text(
                  'Student Portal',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_getMenuIcon(index)),
                  title: Text(_menuItems[index]),
                  selected: _selectedIndex == index,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMenuIcon(int index) {
    switch (index) {
      case 0: return Icons.dashboard;
      case 1: return Icons.book;
      case 2: return Icons.assignment;
      case 3: return Icons.assessment;
      case 4: return Icons.calendar_today;
      default: return Icons.dashboard;
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const StudentDashboardScreen();
      case 1:
        return const StudentCoursesScreen();
      case 2:
        return const StudentAssessmentsScreen();
      case 3:
        return const StudentReportsScreen();
      case 4:
        return const StudentAttendanceScreen();
      default:
        return const StudentDashboardScreen();
    }
  }

  Widget _buildPlaceholder(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}