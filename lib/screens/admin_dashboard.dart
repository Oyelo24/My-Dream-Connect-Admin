import 'package:flutter/material.dart';
import 'attendance_management_screen.dart';
import 'assessment_management_screen.dart';
import 'settings_screen.dart';
import 'student_management.dart';
import 'analytics_screen.dart';
import 'track_management_screen.dart';
import 'module_management_screen.dart';
import '../services/admin_dashboard_service.dart';
import '../models/student.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final AdminDashboardService _dashboardService = AdminDashboardService();
  
  // Dashboard data
  Map<String, dynamic> _dashboardStats = {};
  List<Student> _recentStudents = [];
  List<Map<String, dynamic>> _recentActivity = [];
  List<Map<String, dynamic>> _upcomingAssessments = [];
  bool _isLoading = true;

  final List<String> _menuItems = [
    'Dashboard',
    'Student Management',
    'Track Management',
    'Attendance Management',
    'Assessment Management',
    'Module Management',
    'Analytics',
    'Settings'
  ];
  final Map<String, String> _appConfig = {
    'appName': 'MDC Admin',
    'appSubtitle': 'Panel',
    'initials': 'MA'
  };

  final Map<String, Color> _themeColors = {
    'primary': const Color(0xFF4A90E2),
    'secondary': const Color(0xFF4CAF50),
    'accent': const Color(0xFFFF9800),
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final stats = await _dashboardService.getDashboardStats();
      final students = await _dashboardService.getRecentStudents();
      final activity = await _dashboardService.getRecentActivity();
      final assessments = await _dashboardService.getUpcomingAssessments();
      
      setState(() {
        _dashboardStats = stats;
        _recentStudents = students;
        _recentActivity = activity;
        _upcomingAssessments = assessments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          // Sidebar - only show on desktop
          if (!isMobile)
            Container(
              width: isTablet ? 200 : 250,
              color: const Color(0xFF2C3E50),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _themeColors['primary'],
                          child: Text(
                            _appConfig['initials'] ?? 'A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _appConfig['appName'] ?? 'Admin',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _appConfig['appSubtitle'] ?? 'Panel',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  // Menu Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIndex == index;
                        return ListTile(
                          leading: Icon(
                            _getMenuIcon(index),
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                          title: Text(
                            _menuItems[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: Colors.white12,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: isMobile ? 60 : 80,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isMobile)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getPageTitle(),
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (!isMobile)
                              Text(
                                _getPageSubtitle(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!isMobile)
                        Row(
                          children: [
                            if (_selectedIndex == 1)
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('Enroll Students'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _themeColors['primary'],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            const SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.logout, size: 16),
                              label: const Text('Sign Out'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      if (isMobile)
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {},
                        ),
                    ],
                  ),
                ),
                // Content Area
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMenuIcon(int index) {
    switch (index) {
      case 0: return Icons.dashboard;
      case 1: return Icons.people;
      case 2: return Icons.track_changes;
      case 3: return Icons.check_circle;
      case 4: return Icons.assignment;
      case 5: return Icons.extension;
      case 6: return Icons.analytics;
      case 7: return Icons.settings;
      default: return Icons.menu;
    }
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0: return 'Dashboard';
      case 1: return 'Student Management';
      case 2: return 'Track Management';
      case 3: return 'Attendance Management';
      case 4: return 'Assessment Management';
      case 5: return 'Module Management';
      case 6: return 'Analytics';
      case 7: return 'Settings';
      default: return 'Dashboard';
    }
  }

  String _getPageSubtitle() {
    switch (_selectedIndex) {
      case 0: return 'Overview of your tech cohort';
      case 1: return 'Manage student records and enrollment';
      case 2: return 'Manage learning tracks and curriculum';
      case 3: return 'Track and manage attendance';
      case 4: return 'Create and manage assessments';
      case 5: return 'Manage learning modules';
      case 6: return 'View reports and analytics';
      case 7: return 'System configuration';
      default: return 'Welcome to the admin panel';
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const StudentManagement();
      case 2:
        return const TrackManagementScreen();
      case 3:
        return const AttendanceManagementScreen();
      case 4:
        return const AssessmentManagementScreen();
      case 5:
        return const ModuleManagementScreen();
      case 6:
        return const AnalyticsScreen();
      case 7:
        return const SettingsScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(),
          const SizedBox(height: 24),
          MediaQuery.of(context).size.width < 768
              ? Column(
                  children: [
                    _buildRecentStudents(),
                    const SizedBox(height: 20),
                    _buildUpcomingAssessments(),
                    const SizedBox(height: 20),
                    _buildRecentActivity(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildRecentStudents(),
                          const SizedBox(height: 20),
                          _buildUpcomingAssessments(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildRecentActivity(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = [
      {
        'title': 'Total Students',
        'value': '${_dashboardStats['totalStudents'] ?? 0}',
        'icon': Icons.people,
        'color': _themeColors['primary']!,
        'change': '+12%',
      },
      {
        'title': 'Total Courses',
        'value': '${_dashboardStats['totalCourses'] ?? 0}',
        'icon': Icons.book,
        'color': _themeColors['secondary']!,
        'change': '+5%',
      },
      {
        'title': 'Assessments',
        'value': '${_dashboardStats['totalAssessments'] ?? 0}',
        'icon': Icons.assignment,
        'color': _themeColors['accent']!,
        'change': '+8%',
      },
      {
        'title': 'Attendance Rate',
        'value': '${(_dashboardStats['attendanceRate'] ?? 0.0).toStringAsFixed(1)}%',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'change': '+3%',
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 768 ? 2 : 4;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 24,
                    ),
                    Text(
                      stat['change'] as String,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stat['title'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentStudents() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Students',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_recentStudents.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No students found'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentStudents.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final student = _recentStudents[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _themeColors['primary'],
                      child: Text(
                        student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(student.name),
                    subtitle: Text(student.email),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          student.attendance,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          student.lastSeen,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAssessments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Assessments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_upcomingAssessments.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No upcoming assessments'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _upcomingAssessments.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final assessment = _upcomingAssessments[index];
                  return ListTile(
                    leading: Icon(
                      Icons.assignment,
                      color: _themeColors['accent'],
                    ),
                    title: Text(assessment['title']),
                    subtitle: Text('${assessment['type']} • ${assessment['course']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          assessment['dueDate'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${assessment['totalMarks']} marks',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_recentActivity.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No recent activity'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentActivity.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activity = _recentActivity[index];
                  return ListTile(
                    leading: Icon(
                      _getActivityIcon(activity['icon']),
                      color: activity['type'] == 'submission' 
                          ? Colors.green 
                          : Colors.blue,
                    ),
                    title: Text(activity['title']),
                    subtitle: Text(activity['description']),
                    trailing: Text(
                      activity['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String iconName) {
    switch (iconName) {
      case 'assignment_turned_in':
        return Icons.assignment_turned_in;
      case 'check_circle':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color(0xFF2C3E50),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'MDC Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return ListTile(
                    leading: Icon(
                      _getMenuIcon(index),
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    title: Text(
                      _menuItems[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Colors.white12,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}