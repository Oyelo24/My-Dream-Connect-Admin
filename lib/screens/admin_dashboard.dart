import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../services/track_service.dart';
import '../models/track.dart';
import 'student_management.dart';
import 'attendance_management_screen.dart';
import 'assessment_management_screen.dart';
import 'analytics_dashboard_screen.dart';

import 'settings_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Dashboard data
  late List<String> _menuItems;
  late Map<String, String> _appConfig;
  late Map<String, dynamic> _statistics;
  late List<Map<String, String>> _recentActivities;
  late List<Map<String, String>> _urgentTasks;
  late List<Map<String, String>> _upcomingAssessments;
  late Map<String, dynamic> _assessmentProgress;
  Map<String, Color> _themeColors = DashboardService.getThemeColors();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load all dashboard data
      _menuItems = DashboardService.getMenuItems();
      _appConfig = DashboardService.getAppConfig();
      _statistics = await DashboardService.getStatistics();
      _recentActivities = await DashboardService.getRecentActivities();
      _urgentTasks = await DashboardService.getUrgentTasks();
      _upcomingAssessments = await DashboardService.getUpcomingAssessments();
      _assessmentProgress = await DashboardService.getAssessmentProgress();
      _themeColors = DashboardService.getThemeColors();
    } catch (e) {
      // Use default values if loading fails
      _menuItems = DashboardService.getMenuItems();
      _appConfig = DashboardService.getAppConfig();
      _statistics = {
        'totalStudents': {'value': '0', 'change': '', 'color': 0xFF4A90E2},
        'activeStudents': {'value': '0', 'change': '', 'color': 0xFF4CAF50},
        'totalAssessments': {'value': '0', 'change': '', 'color': 0xFFFF9800},
        'attendanceRate': {'value': '0%', 'change': '', 'color': 0xFF2C3E50},
      };
      _recentActivities = [];
      _urgentTasks = [];
      _upcomingAssessments = [];
      _assessmentProgress = {
        'completed': '0/0',
        'percentage': 0.0,
        'averageGrade': 'N/A',
      };
      _themeColors = DashboardService.getThemeColors();
    }

    setState(() {});
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
                            DashboardService.getMenuIcon(index),
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
                        color: Colors.grey.withOpacity(0.1),
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

  String _getPageTitle() {
    return DashboardService.getPageTitle(_selectedIndex);
  }

  String _getPageSubtitle() {
    return DashboardService.getPageSubtitle(_selectedIndex);
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const StudentManagement();
      case 2:
        return _buildAttendanceContent();
      case 3:
        return _buildAssessmentContent();
      case 4:
        return _buildAnalyticsContent();
      case 5:
        return _buildTrackManagementContent();
      case 6:
        return _buildInstructorManagementContent();
      case 7:
        return const SettingsScreen();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          // Stats Cards Row
          isMobile
              ? Column(
                  children: [
                    _buildStatCard(
                      'Total Students',
                      _statistics['totalStudents']['value'],
                      _statistics['totalStudents']['change'],
                      Color(_statistics['totalStudents']['color']),
                      Icons.people,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      'Active Students',
                      _statistics['activeStudents']['value'],
                      _statistics['activeStudents']['change'],
                      Color(_statistics['activeStudents']['color']),
                      Icons.check_circle,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      'Total Assessments',
                      _statistics['totalAssessments']['value'],
                      _statistics['totalAssessments']['change'],
                      Color(_statistics['totalAssessments']['color']),
                      Icons.assignment,
                    ),
                    const SizedBox(height: 16),
                    _buildAttendanceCard(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Students',
                        _statistics['totalStudents']['value'],
                        _statistics['totalStudents']['change'],
                        Color(_statistics['totalStudents']['color']),
                        Icons.people,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Active Students',
                        _statistics['activeStudents']['value'],
                        _statistics['activeStudents']['change'],
                        Color(_statistics['activeStudents']['color']),
                        Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Total Assessments',
                        _statistics['totalAssessments']['value'],
                        _statistics['totalAssessments']['change'],
                        Color(_statistics['totalAssessments']['color']),
                        Icons.assignment,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildAttendanceCard(),
                  ],
                ),
          const SizedBox(height: 24),
          // Content Row
          isMobile
              ? Column(
                  children: [
                    SizedBox(height: 300, child: _buildRecentActivities()),
                    const SizedBox(height: 24),
                    SizedBox(height: 200, child: _buildAssessmentProgress()),
                    const SizedBox(height: 24),
                    SizedBox(height: 300, child: _buildUrgentTasks()),
                    const SizedBox(height: 24),
                    SizedBox(height: 200, child: _buildUpcomingAssessments()),
                  ],
                )
              : SizedBox(
                  height: 600,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(child: _buildRecentActivities()),
                            const SizedBox(height: 24),
                            Expanded(child: _buildAssessmentProgress()),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Right Column
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(child: _buildUrgentTasks()),
                            const SizedBox(height: 24),
                            Expanded(child: _buildUpcomingAssessments()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: isMobile ? double.infinity : 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Rate',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _statistics['attendanceRate']['value'],
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, size: 20),
              SizedBox(width: 8),
              Text(
                'Recent Student Activities',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Latest student interactions and submissions',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _recentActivities.isEmpty
                ? const Center(
                    child: Text(
                      'No recent activities',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _recentActivities.length,
                    itemBuilder: (context, index) {
                      final activity = _recentActivities[index];
                      return _buildActivityItem(
                        activity['name'] ?? '',
                        activity['action'] ?? '',
                        activity['time'] ?? '',
                        activity['score'] ?? '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String name,
    String action,
    String time,
    String score,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _themeColors['primary'],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          color: _themeColors['primary'],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: ' $action',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    if (score.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          score,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assessment Progress',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Bootcamp curriculum completion status',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Completed Assessments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _assessmentProgress['percentage'],
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _themeColors['primary']!,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _assessmentProgress['completed'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  const Text(
                    'Average Grade',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _themeColors['success'],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _assessmentProgress['averageGrade'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentTasks() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.priority_high, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'Urgent Tasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Items that need immediate attention',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _urgentTasks.isEmpty
                ? const Center(
                    child: Text(
                      'No urgent tasks',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _urgentTasks.length,
                    itemBuilder: (context, index) {
                      final task = _urgentTasks[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle task tap if needed
                        },
                        child: _buildTaskItem(
                          task['task'] ?? '',
                          task['priority'] ?? 'LOW',
                          _getPriorityColor(task['priority'] ?? 'LOW'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String task, String priority, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              priority,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(task, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildUpcomingAssessments() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule, size: 20),
              SizedBox(width: 8),
              Text(
                'Upcoming Assessments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Scheduled assessments this month',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _upcomingAssessments.isEmpty
                ? const Center(
                    child: Text(
                      'No upcoming assessments',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _upcomingAssessments.length,
                    itemBuilder: (context, index) {
                      final assessment = _upcomingAssessments[index];
                      return _buildAssessmentItem(
                        assessment['title'] ?? '',
                        assessment['date'] ?? '',
                        assessment['students'] ?? '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentItem(String title, String date, String students) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(
            students,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceContent() {
    return const AttendanceManagementScreen();
  }

  Widget _buildAssessmentContent() {
    return const AssessmentManagementScreen();
  }

  Widget _buildAnalyticsContent() {
    return const AnalyticsDashboardScreen();
  }

  Widget _buildTrackManagementContent() {
    final tracks = TrackService.getTechTracks();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tech Tracks',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage available tech tracks and curriculum',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Track'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeColors['primary'],
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: isMobile
                ? ListView.builder(
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTrackCard(tracks[index]),
                      );
                    },
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      return _buildTrackCard(tracks[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorManagementContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructors',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage instructors and their assignments',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Instructor Management',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Instructor management will be implemented based on your requirements',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
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
                      DashboardService.getMenuIcon(index),
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

  Widget _buildTrackCard(Track track) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                track.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${track.duration} weeks',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: track.isActive ? Colors.green[100] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  track.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 10,
                    color: track.isActive ? Colors.green[700] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            track.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${track.enrolledStudents} students',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Manage'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
